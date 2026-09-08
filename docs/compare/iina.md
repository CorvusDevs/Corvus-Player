# Corvus Player vs IINA

Corvus Player and IINA are native macOS media players powered by mpv. Corvus Player goes further by turning advanced playback, audio, streaming, library, and macOS capabilities into one polished, discoverable application.

**Legend:** ✅ included and integrated, ❌ missing as a dedicated built-in feature or requires extra setup.

## At a glance

| Capability | Corvus Player | IINA 1.4.4 |
|---|---|---|
| Advanced mpv controls | ✅ More than 200 options surfaced through native, purpose-built controls | ❌ Many advanced options require manual names, values, or configuration files |
| Settings discovery | ✅ Meaning-aware search across names, descriptions, sections, keywords, localized text, and typos | ❌ Search is limited to labels and sections exposed in preference panels |
| Audio personalization | ✅ AutoEQ with 6,033 profiles, automatic device matching, per-device memory, crossfeed, and loudness tools | ❌ No equivalent integrated audio-personalization suite found |
| Streaming experience | ✅ Built-in yt-dlp management, quality switching, browser cookies, SponsorBlock, and cache presets | ❌ Requires extra setup or plugins for several of these capabilities |
| Media library and queue | ✅ Folder scanning, artwork, persistent library items, playlists, session restoration, and Up Next | ❌ No equivalent integrated library and temporary queue found |
| macOS integration | ✅ Spotlight, Shortcuts, Focus filters, menu bar playback, Quick Look, and Media Extensions | ❌ No equivalent integrated system toolkit found |
| Subtitle sources | ✅ OpenSubtitles and SubDL are integrated, with dual tracks and visual styling presets | ❌ Online search requires a plugin and no SubDL integration was found |
| Synced lyrics | ✅ Local LRC and LRClib lyrics with live highlighting and click-to-seek | ❌ No built-in lyrics experience found |
| Finder experience | ✅ Album artwork, representative video icons, Quick Look previews, and MKV and WebM support | ❌ No equivalent Finder extension suite found |
| Visual configuration | ✅ Built-in galleries and presets for shaders, playback, EQ, subtitles, and tone mapping | ❌ Advanced setups often require profiles, custom files, manual options, or plugins |

## Features Corvus Player provides as dedicated, integrated tools

### Audio and music

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| AutoEQ database | ✅ 6,033 headphone and earphone correction profiles | ❌ No dedicated built-in AutoEQ feature found |
| Automatic headphone matching | ✅ Applies the matching correction when the audio output changes | ❌ No equivalent built-in feature found |
| Per-device EQ memory | ✅ Remembers a separate curve for each output device | ❌ No equivalent built-in feature found |
| Adjustable EQ band width | ✅ Ten bands with gain and width controls plus saveable presets | ❌ Ten-band EQ uses fixed-width filters |
| AutoEQ import | ✅ Accepts AutoEQ GraphicEQ text | ❌ No dedicated importer found |
| Crossfeed | ✅ Dedicated adjustable control | ❌ Requires manual mpv or filter configuration |
| Loudness compensation | ✅ Dedicated adjustable control | ❌ No dedicated built-in control found |
| Night mode | ✅ One control compresses loud and quiet passages for late-night viewing | ❌ No dedicated built-in mode found |
| Channel tools | ✅ Balance and mono fold-down controls | ❌ No equivalent dedicated control group found |
| Real-time audio visualizer | ✅ Spectrum bars, mirrored bars, waveform, and spectrum curve | ❌ No built-in audio visualizer found |
| Synced lyrics | ✅ Local LRC files and optional LRClib lookup | ❌ No built-in lyrics experience found |
| Interactive lyrics | ✅ Active-line highlighting and click-to-seek | ❌ No equivalent built-in feature found |

### Streaming

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| yt-dlp lifecycle | ✅ Integrated management and settings | ❌ Requires the official Online Media plugin |
| In-player quality switching | ✅ Integrated into the playback controls | ❌ Requires the official Online Media plugin |
| Browser-cookie authentication | ✅ Dedicated Safari, Chrome, and Firefox setting | ❌ Not documented by the official Online Media plugin |
| SponsorBlock | ✅ Converts sponsored segments into chapters | ❌ Not documented by IINA or its official Online Media plugin |
| Stream cache presets | ✅ Integrated settings and playback presets | ❌ Requires mpv option configuration |

### Organization and macOS integration

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| Up Next | ✅ Temporary queue that leaves playlist order unchanged | ❌ No equivalent built-in queue found |
| Media library | ✅ Folder scanning, persistent items, artwork, and playlists | ❌ No equivalent built-in library found; a community File Viewer plugin is listed |
| Spotlight library search | ✅ Library items are indexed into macOS Spotlight | ❌ No Core Spotlight integration found |
| Shortcuts actions | ✅ Play or Pause, Seek, Set Speed, and Open File | ❌ No App Intents integration found |
| Focus filter | ✅ A Focus can automatically enable Night mode | ❌ No Focus filter integration found |
| Menu bar mini player | ✅ Optional playback controls in the menu bar | ❌ No built-in menu bar player found |
| Finder artwork icons | ✅ Writes album art or a representative video frame as the file icon | ❌ No equivalent built-in feature found |
| Quick Look extensions | ✅ Ships preview and thumbnail extensions | ❌ Does not ship equivalent extension targets |
| Matroska and WebM Media Extension | ✅ Optional system-level preview support for MKV and WebM | ❌ No Media Extension target found |

### The power of mpv, without editing configuration files

Corvus Player preserves direct `mpv.conf` passthrough for experts while making far more of mpv's power discoverable and configurable without learning option names or editing text files.

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| Advanced mpv options in the GUI | ✅ More than 200 settings exposed through native controls and organized by purpose | ❌ Many advanced options require manual name and value entry or configuration files |
| Settings search depth | ✅ Searches names, descriptions, sections, synonyms, keywords, and localized text, with typo tolerance | ❌ Searches the visible labels and sections exposed by its preference panels |
| Exact settings navigation | ✅ Search results open the precise setting and section | ❌ Search primarily navigates to matching preference labels |
| Guided advanced configuration | ✅ Human-readable descriptions, contextual guidance, and appropriate switches, sliders, and menus | ❌ Unsurfaced options require knowing the mpv option name and entering its value manually |
| Presets and visual configuration | ✅ Built-in presets and galleries for playback, EQ, shaders, subtitles, and tone mapping | ❌ Advanced configurations often require profiles, custom files, manual options, or plugins |
| Recent settings searches | ✅ Recent searches remain available beneath the search field | ❌ No persistent recent-settings workflow found |

### Subtitles, video, and customization

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| Subtitle providers | ✅ OpenSubtitles and SubDL are integrated | ❌ OpenSubtitles requires an official plugin; no SubDL integration found |
| Curated shader gallery | ✅ Anime4K, CAS, adaptive sharpening, and other included choices | ❌ Custom shaders require setup; Anime4K is a community plugin |
| Shader stacking | ✅ Browse, combine, reorder, and toggle shaders during playback | ❌ No equivalent built-in gallery found |
| Playback presets | ✅ Named presets coordinate related playback and interface settings | ❌ Requires profiles or mpv configuration |

## Why Corvus Player feels different

Corvus Player is designed around discovery. Advanced features are presented as named controls, searchable settings, galleries, presets, and contextual explanations. You do not need to know mpv option names or find a plugin before discovering AutoEQ, Night mode, SponsorBlock, lyrics, Finder previews, or macOS automation.

The visual design follows the same idea. Player controls, Music Mode, artwork, Settings, the media library, and utility panels share one hierarchy and interaction language. Advanced capabilities look and behave like parts of the same application, not separate technical layers. The result is a richer, more guided mpv experience that remains unmistakably native to macOS.

## Verification and sources

This comparison was verified on September 8, 2026 against:

- [IINA 1.4.4 source and feature list](https://github.com/iina/iina/tree/v1.4.4)
- [IINA 1.4.4 release](https://github.com/iina/iina/releases/tag/v1.4.4)
- [IINA 1.5.0 beta 1 release notes](https://github.com/iina/iina/releases/tag/v1.5.0-beta1)
- [IINA current preference search implementation](https://github.com/iina/iina/blob/develop/iina/PreferenceWindowController.swift)
- [IINA current advanced preference implementation](https://github.com/iina/iina/blob/develop/iina/PrefAdvancedViewController.swift)
- [IINA official Online Media plugin](https://github.com/iina/plugin-online-media)
- [IINA official OpenSubtitles plugin](https://github.com/iina/plugin-opensub)
- [IINA documented plugin list](https://github.com/iina/iina/tree/v1.4.4#iina-plugins-list)
- Corvus Player source, settings index, application targets, bundled resources, and currently published feature list

“No feature found” means that no dedicated implementation was found in IINA 1.4.4, the active IINA development branch, or the documented official plugins under the feature name and related framework symbols. Some results may still be achievable with custom mpv configuration, scripts, or community plugins. The IINA 1.5 stable release should be checked again when it ships.
