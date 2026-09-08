<div align="center">

<img src="https://corvusdevs.github.io/Corvus-Player/icon.png" width="200" height="200" alt="Corvus Player icon">

# Corvus Player

**The most powerful and customizable media player for macOS**

<p>
  <img src="https://img.shields.io/github/v/release/CorvusDevs/Corvus-Player?style=flat-square&color=2d7ff9&label=release" alt="Latest release">
  <img src="https://img.shields.io/github/downloads/CorvusDevs/Corvus-Player/total?style=flat-square&color=4CAF50&label=downloads" alt="Total downloads">
  <img src="https://img.shields.io/badge/macOS-15.0+-000000?style=flat-square&logo=apple&logoColor=white" alt="macOS 15.0+">
  <img src="https://img.shields.io/badge/Apple%20Silicon-supported-444?style=flat-square&logo=apple&logoColor=white" alt="Apple Silicon">
</p>

<p>
  <a href="https://github.com/CorvusDevs/Corvus-Player/releases/latest"><img src="https://img.shields.io/badge/%E2%AC%87%20Download%20for%20macOS-2d7ff9?style=for-the-badge&logoColor=white" alt="Download for macOS" height="44"></a>
</p>

<p>
  <a href="https://corvusdevs.github.io/Corvus-Player/">Website</a> ·
  <a href="https://github.com/CorvusDevs/Corvus-Player/releases">Releases</a> ·
  <a href="#why-corvus-player">Why Corvus</a> ·
  <a href="#privacy">Privacy</a>
</p>

<p>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=ar"><img src="docs/flags/ar.svg" width="20" alt="العربية"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=zh-Hans"><img src="docs/flags/zh-Hans.svg" width="20" alt="简体中文"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=de"><img src="docs/flags/de.svg" width="20" alt="Deutsch"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=es"><img src="docs/flags/es.svg" width="20" alt="Español"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=fr"><img src="docs/flags/fr.svg" width="20" alt="Français"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=hi"><img src="docs/flags/hi.svg" width="20" alt="हिन्दी"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=it"><img src="docs/flags/it.svg" width="20" alt="Italiano"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=ja"><img src="docs/flags/ja.svg" width="20" alt="日本語"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=ko"><img src="docs/flags/ko.svg" width="20" alt="한국어"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=pt-BR"><img src="docs/flags/pt-BR.svg" width="20" alt="Português"></a>
  <a href="https://corvusdevs.github.io/Corvus-Player/?lang=ru"><img src="docs/flags/ru.svg" width="20" alt="Русский"></a>
  <sub>+ 25 more languages</sub>
</p>

</div>

---

Built on **mpv** with a native **SwiftUI** interface. GPU-accelerated playback, real-time GLSL shaders, full streaming via yt-dlp, 200+ settings, and zero tracking. Free forever, with an optional Supporter upgrade that funds development.

## Contents

- [Features](#features)
- [Corvus Player vs IINA](#corvus-player-vs-iina)
- [What makes Corvus Player special](#what-makes-corvus-player-special)
- [Built with](#built-with)
- [Privacy](#privacy)
- [More from CorvusDevs](#more-from-corvusdevs)

## Features

- **Plays everything.** All major video and audio formats with hardware-accelerated decoding via VideoToolbox.
- **Real-time GLSL shaders.** Apply and customize shaders during playback with a built-in shader gallery. Anime4K, adaptive sharpening, CAS.
- **Stream anything.** Full yt-dlp integration for YouTube, Twitch, SoundCloud, and hundreds of sites. SponsorBlock, browser cookies, quality switcher.
- **HDR & EDR.** Extended dynamic range output for HDR content; accurate tone mapping presets for SDR.
- **200+ settings.** Obsessively customizable playback, video, audio, subtitle, and interface options. Searchable across every tab.
- **Best-in-class subtitles.** Auto-load, online search via OpenSubtitles and SubDL, one-tap styling presets, SDH support, dual tracks, full ASS/SSA styling.
- **Night mode.** Dynamic-range compression that evens out loud and quiet passages so late-night dialogue stays clear without sudden blasts.
- **Up Next queue.** Line up what plays next without reordering your playlist, with pinch-to-zoom and pan, plus on-disk stream caching for instant backward seeks.
- **Deep macOS integration.** A menu bar mini player, Shortcuts and App Intents, Spotlight library indexing, and a Focus filter, alongside Now Playing and media-key support.
- **Music mode.** Dedicated UI with album art display, audio visualizer, gapless playback, ReplayGain.
- **Audiophile equalizer.** A dedicated Equalizer tab with a 10-band parametric EQ, adjustable per-band width, and 18 saveable presets. Device Equalization brings AutoEQ corrections for 6,000+ headphones and earphones, matched to your output device automatically, plus crossfeed, loudness compensation, channel balance, mono, and per-device EQ memory.
- **Synced lyrics.** Karaoke-style, time-synced lyrics in music mode. Fetch them from LRClib manually or enable automatic lookup, or load local .lrc files, with the active line highlighted and click-to-jump on any line.
- **Playlists & library.** Drag-and-drop playlists with thumbnails, media library with folder scanning, session persistence.
- **Picture-in-picture.** Compact floating mini player that stays on top.
- **Seekbar thumbnails.** Hover over the seekbar to preview frames at any moment.
- **Album art & video previews in Finder.** Every song and video gets real album art (audio) or a representative video frame (video) as its Finder icon. Works for MKV, WebM, Opus, OGG, FLAC, DSD, and 20+ formats macOS normally shows as a generic music note or filmstrip. Quick Look preview works too.
- **Chapter navigation.** Full support for video chapters with quick navigation. MKV chapters, YouTube chapters, SponsorBlock segments.
- **Smart shortcuts.** Customizable keyboard shortcuts plus trackpad gestures. Pinch to zoom, swipe to seek, two-finger tap to pause.
- **mpv under the hood.** Built on libmpv for battle-tested, high-performance media playback.
- **Truly native macOS.** SwiftUI + AppKit, not an Electron wrapper. Quick Look extensions, Dock menus, system integration that feels Apple-built.
- **36 languages.** Fully localized with searchable settings in every language. RTL support for Arabic and Hebrew.
- **Built for accessibility.** Full VoiceOver labeling of the playback controls, with support for Reduce Motion, Increase Contrast, and Reduce Transparency. Optional trackpad haptics.

## Corvus Player vs IINA

Both apps are native macOS players built on mpv. Corvus Player is the stronger fit when you want the power of mpv exposed through a polished interface, with advanced features already integrated, searchable, and designed as one coherent experience instead of assembled through plugins or manual configuration.

| Capability | Corvus Player | IINA 1.4.4 |
|---|---|---|
| Advanced mpv options in the GUI | ✅ **200+ settings exposed through native controls**, organized by purpose | ❌ **Many advanced mpv options require manual name and value entry or configuration files** |
| Settings search depth | ✅ **Searches names, descriptions, sections, synonyms, keywords, and localized text, with typo tolerance** | ❌ **Searches the labels and sections exposed by its preference panels** |
| Exact settings navigation | ✅ **Search results open the precise setting and section** | ❌ **Search primarily navigates to matching preference labels** |
| Guided advanced configuration | ✅ **Human-readable descriptions, contextual guidance, and appropriate switches, sliders, and menus** | ❌ **Unsurfaced options require knowing the mpv option name and entering its value manually** |
| Presets and visual configuration | ✅ **Built-in presets and galleries for playback, EQ, shaders, subtitles, and tone mapping** | ❌ **Advanced configurations often require profiles, custom files, manual options, or plugins** |
| Streaming without setup | ✅ **Integrated:** yt-dlp, quality switching, browser cookies, and SponsorBlock chapters | ❌ **Plugin required:** quality switching needs Online Media; SponsorBlock is not documented there |
| Subtitle sources | ✅ **Two integrated sources:** OpenSubtitles and SubDL | ❌ **Plugin required:** OpenSubtitles only; no SubDL integration found |
| Media library | ✅ **Built in:** folder scanning, artwork, playlists, and session restoration | ❌ **No equivalent built-in library found** |
| AutoEQ headphone correction | ✅ **Built in:** 6,033 profiles and automatic output-device matching | ❌ **Not built in** |
| Synced lyrics | ✅ **Built in:** local LRC and optional LRClib lookup | ❌ **No built-in lyrics experience found** |
| Night listening tools | ✅ **Built in:** Night mode, crossfeed, loudness compensation, balance, and mono | ❌ **No dedicated controls found** |
| Finder integration | ✅ **Built in:** custom media icons plus Quick Look and Media Extensions | ❌ **No equivalent Finder extensions** |
| Up Next queue | ✅ **Built in:** temporary queue that preserves playlist order | ❌ **No equivalent queue found** |
| Spotlight library search | ✅ **Built in:** indexed media opens directly from macOS search | ❌ **No Core Spotlight integration found** |
| Shortcuts and Focus | ✅ **Built in:** App Intents and a Night mode Focus filter | ❌ **No equivalent built-in integrations found** |
| Menu bar playback | ✅ **Built-in menu bar mini player** | ❌ **No built-in menu bar player found** |
| Shader experience | ✅ **Built-in gallery:** Anime4K, CAS, adaptive sharpening, stacking, and presets | ❌ **Manual or plugin setup:** custom shaders and a community Anime4K plugin |
| Audio visualization | ✅ **Built in:** four real-time spectrum and waveform styles | ❌ **No built-in visualizer found** |
| Recent settings searches | ✅ **Recent searches remain available beneath the search field** | ❌ **No persistent recent-settings workflow found** |

[See the detailed, sourced comparison](docs/compare/iina.md), including areas where the players match and where IINA may be the better fit.

## What makes Corvus Player special

🎨 **A built-in GLSL shader gallery.** Browse, stack, and toggle shaders in real time. Anime4K upscaling, adaptive sharpening, CAS, custom presets. The whole library is one click away during playback.

🖼️ **Universal Finder thumbnails.** Every song and video shows real album art or a representative video frame as its Finder icon, including the formats macOS normally renders as a generic music note or filmstrip (MKV, WebM, Opus, OGG, FLAC, DSD, and 20+ more). Quick Look previews work too. A background helper keeps thumbnails fresh even when Corvus Player is fully closed.

🔍 **Settings you can actually find.** Searchable across every tab, with deep-linking from quick-action prompts. 200+ options, but you'll never have to hunt for them.

🌐 **36 languages, fully translated.** Including the searchable settings and onboarding. RTL layout flip for Arabic and Hebrew. The language picker is one click away.

⚡ **GPU-accelerated playback on Apple Silicon.** Built on mpv with VideoToolbox decoding and Metal rendering. 4K HDR plays smoothly; the CVDisplayLink-driven render loop keeps frame pacing rock-solid even during fullscreen transitions.

🎵 **A real music mode, not an afterthought.** Album art display, audio visualizer, gapless playback, ReplayGain, compact floating mini player. Works as your media library and your music player.

🎬 **Streaming without the browser.** Paste any URL: YouTube, Twitch, SoundCloud, hundreds of sites via yt-dlp. SponsorBlock, browser-cookie auth, quality switcher, subtitle fetching all built in.

🛡️ **Built for privacy.** Zero accounts, zero telemetry, zero analytics. Corvus Player contacts the update feed when automatic update checks are enabled. Streaming, online subtitles, optional automatic lyrics lookup, and license activation contact their named services only when those features are used.

## Built with

**mpv** · **SwiftUI** · **AppKit** · **Metal** · **VideoToolbox** · **yt-dlp** · **Sparkle** · **OpenSubtitles**

## Privacy

Free forever. No accounts, analytics, telemetry, or tracking. Automatic update checks are enabled by default and can be disabled in Settings. Streaming, online subtitles, optional automatic lyrics lookup, and one-time license activation contact their named services when used. Activated licenses are then stored in the macOS Keychain.

## Open-source notices

Corvus Player is proprietary software. It bundles several open-source libraries, including FFmpeg and mpv, used under the GNU Lesser General Public License v2.1 (LGPL-2.1) with no GPL-licensed components. These libraries are linked dynamically and ship as separate, replaceable files inside the app.

The complete corresponding source for the LGPL libraries (FFmpeg n8.1.2 and mpv v0.41.0, built from their unmodified upstream releases with the configuration noted in the license file) is available on request at corvusdevs@outlook.com. Full per-library license details, including the LGPL-2.1 text, are in [THIRD_PARTY_LICENSES.txt](THIRD_PARTY_LICENSES.txt).

## More from CorvusDevs

| | App | Description |
|---|-----|-------------|
| <img src="https://corvusdevs.github.io/icons/corvus-rss.png" width="32"> | [Corvus RSS Reader](https://corvusdevs.github.io/Corvus-RSS-Reader-For-Safari/) | Privacy-first RSS reader for Safari |
| <img src="https://corvusdevs.github.io/icons/purple-crow.png" width="32"> | [Purple Crow for Safari](https://corvusdevs.github.io/Purple-Crow-For-Safari/) | BTTV, FFZ & 7TV emotes plus 50+ Twitch features |
| <img src="https://corvusdevs.github.io/icons/red-crow.png" width="32"> | [Red Crow for Safari](https://corvusdevs.github.io/Red-Crow-For-Safari/) | YouTube speed control, SponsorBlock, and 40+ features |
| <img src="https://corvusdevs.github.io/icons/auto-mute-tab.png" width="32"> | [Auto Mute Tab for Safari](https://corvusdevs.github.io/Auto-Mute-Tab-For-Safari/) | Only the focused tab plays audio |
| <img src="https://corvusdevs.github.io/icons/ekual.png" width="32"> | [Ekual](https://corvusdevs.github.io/Ekual/) | Automatic loudness equalization for macOS |
| <img src="https://corvusdevs.github.io/icons/tekla.png" width="32"> | [Tekla](https://corvusdevs.github.io/Tekla/) | Swipe-to-type virtual keyboard for macOS |

---

<div align="center">

<a href="https://star-history.com/#CorvusDevs/Corvus-Player&Date">
  <img src="https://api.star-history.com/svg?repos=CorvusDevs/Corvus-Player&type=Date" alt="Star history" width="600">
</a>

<sub>Made with care by <a href="https://corvusdevs.github.io">CorvusDevs</a></sub>

</div>
