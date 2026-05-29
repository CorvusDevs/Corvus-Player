# NSWindowController Port — Architecture & Phasing

> **Status 2026-05-26: DEFERRED.** Receipt-driven analysis (see "Refined diagnosis"
> below) showed the 142 ms cost lives inside NSHostingView's SwiftUI layout
> pass, not the SwiftUI Window scene wrapper. The port alone wouldn't fix
> the perf — it's a prerequisite for layout-stable chrome (Option A) or
> AppKit chrome (Option B). User decision: accept the 142 ms cost on first
> fullscreen toggle. CVDisplayLink refactor (commit 04855f0) already fixed
> the visual artifacts; remaining cost is annoying but not catastrophic.
> Revisit if perf becomes a higher-priority complaint.

## Refined diagnosis (post-revert)

Granular per-step probes localized the 142 ms cost to a single line:
`window.styleMask.remove(.titled)`. This removes the title bar, growing
contentView by ~28 pt; NSHostingView reacts by running SwiftUI's layout
engine over the entire ContentView tree (2016 lines of body code with
100+ subviews, ~1.4 ms per view).

Tried a title-bar-overlay alternative (`.fullSizeContentView` +
transparent title bar + hide standard buttons + `toolbar.isVisible =
false`): perf dropped to ~30 ms, but title-bar area remained visibly
opaque even with `titleVisibility = .hidden`. AppKit insists on drawing
the title-bar strip when `.titled` is set, regardless of transparency
properties.

The cost is fundamental to NSHostingView. Moving the window to an
NSWindowController-managed `NSWindow` with the same NSHostingView inside
does NOT eliminate it — the layout pass happens at the NSHostingView
level, not the scene wrapper level.

---



**Goal:** Eliminate SwiftUI Scene/Toolbar overhead from the main player window so fullscreen toggles, window resizes, and state changes don't trigger expensive `NSHostingView` layout passes. Matches IINA's pure-AppKit chrome pattern.

**Motivation:** The first fullscreen toggle costs ~138 ms of SwiftUI body re-eval because `fullscreenMgr.isFullscreen` is `@Observable` and the body contains a `.toolbar { }` modifier. SwiftUI's toolbar bridge rebuilds NSToolbarItems on every body invalidation. Subsequent toggles are cached but the first-frame stall is user-visible.

## Target architecture (IINA pattern)

```
NSApplication
└── AppDelegate (existing)
    ├── PlayerWindowController (NEW)
    │   ├── PlayerWindow (NEW — NSWindow subclass)
    │   │   ├── NSToolbar (NEW — replaces SwiftUI .toolbar)
    │   │   └── contentView = NSHostingView(ContentView())
    │   └── owns: FullscreenManager state, key window, menu routing
    ├── Settings scene (UNCHANGED — SwiftUI)
    ├── Onboarding scene (UNCHANGED — SwiftUI)
    └── Extra-window registry (NEW — array of PlayerWindowController, replaces SwiftUI WindowGroup)
```

## Phasing

### Phase 1 — AppKit toolbar, SwiftUI window stays

Smallest delta that fixes the root cause:

1. Create `PlayerToolbar.swift` — `NSToolbar` + `NSToolbarDelegate` rendering the 13 toolbar items as `NSToolbarItem` with target/action wiring.
2. Attach the toolbar in `WindowAccessor` once the window is bound.
3. Remove `.toolbar { }` block from `ContentView.swift` (lines 442-448).
4. Remove the opacity hack (was the workaround for invisible icons during fullscreen exit).
5. Each toolbar item action posts a notification or calls into a shared `ContentViewCoordinator` to invoke the existing `toggle…` closures.

**Result expected:** Fullscreen toggle becomes instant. Toolbar visibility is now controlled by `window.toolbar?.isVisible` in `FullscreenManager.enterFullscreen/exitFullscreen` (AppKit, no SwiftUI invalidation).

**Files touched:** ~4 new + 2 modified. Low blast radius.

### Phase 2 — Main window to NSWindowController

If Phase 1 leaves residual costs (sheet presentation, body invalidation on other state):

1. `PlayerWindow.swift` — `NSWindow` subclass with custom `canBecomeKey`, `canBecomeMain`, ESC-to-exit-fullscreen handler.
2. `PlayerWindowController.swift` — owns the window, owns `FullscreenManager` state (moves from singleton to instance), owns toolbar.
3. Replace `Window("Corvus Player", id: "main") { ContentView() }` with `EmptyScene` or remove from `Corvus_PlayerApp.body`.
4. AppDelegate creates the controller in `applicationDidFinishLaunching` and stores in a registry.
5. `ContentView` becomes the root of `NSHostingView` inside the window's contentView.

### Phase 3 — Extra windows to NSWindowController

For multi-file Open With (`"separateWindows"` mode):

1. Drop `WindowGroup(id: "extra", for: UUID.self)`.
2. `ExtraWindowRouter.spawn(url)` instantiates a new `PlayerWindowController` instead of posting a UUID.
3. Each extra window is now a peer `PlayerWindowController` in the registry.

## Compatibility guarantees (per "preemptively fix things")

| Feature | Phase 1 risk | Phase 2 risk | Mitigation |
|---|---|---|---|
| Toolbar item visibility | Medium — must rewire opacity → `isVisible` | Low | Test each item appears/hides correctly |
| Toolbar item enabled state (file loaded vs not) | Medium — must observe `player.isFileLoaded` from delegate | Low | Use NSObjectController or KVO bridge |
| Settings link in toolbar | Medium — `SettingsLink` is SwiftUI-only | Low | Replace with action sending `showSettingsWindow:` to NSApp |
| Submenus (History, Bookmarks, Subtitles, Audio, Tone Mapping) | High — SwiftUI Menu inside ToolbarItemGroup | Medium | Implement as NSMenu attached to `NSToolbarItem.menuFormRepresentation` |
| `.toolbar` accent color tinting | Low — NSToolbarItem inherits window tint | Low | Verify visual parity |
| Multi-window key window routing | Low — already via `NSApp.keyWindow` | Medium — needs registry | Maintain `ActivePlayerTracker` |
| Menu commands (`.menuToggleFullscreen` etc.) | None | Low — still notifications | Keep notification layer |
| File open from dock/Finder | None | None | AppDelegate unchanged |
| Sheets (URL, ShaderGallery, etc.) | None | Low — sheets attach to NSWindow | Keep as SwiftUI sheets on ContentView |
| Drag-drop file import | None | None | `.dropDestination` is inside ContentView body, unaffected |
| Detached playlist NSPanel | None | None | Already AppKit |
| Onboarding window | None | None | Stays SwiftUI Scene |

## Out of scope (stays SwiftUI)

- Settings scene
- Onboarding scene
- All sheets/popovers presented from ContentView
- ContentView body itself (the cost is the Scene chrome wrapper, not the inner view tree)

## Rollback

Each phase is one commit. Phase 1 can be reverted with `git revert <hash>` without touching Phase 2/3. The SwiftUI `.toolbar` block can be restored by uncommenting until validated.
