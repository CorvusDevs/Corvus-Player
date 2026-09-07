# Corvus Player vs IINA

Corvus Player and IINA are native macOS media players powered by mpv. Both handle a wide range of formats, hardware decoding, HDR, subtitles, playlists, chapters, Picture in Picture, Music Mode, seekbar thumbnails, gestures, filters, custom keyboard controls, and advanced playback settings.

The main difference is product philosophy. IINA provides an excellent open-source player and a flexible plugin system. Corvus Player focuses on delivering a broader set of media, audio, library, streaming, and macOS features as one integrated application.

## At a glance

| Capability | Corvus Player | IINA 1.4.4 |
|---|---|---|
| Playback engine | mpv 0.41 and FFmpeg 9 | mpv and FFmpeg |
| Native macOS interface | Yes, SwiftUI and AppKit | Yes, AppKit |
| Hardware decoding and HDR | Yes | Yes |
| Picture in Picture | Yes | Yes |
| Music Mode | Yes | Yes |
| Searchable settings | Yes | Yes |
| Seekbar thumbnails | Yes | Yes |
| Secondary subtitles | Yes | Yes |
| Custom keyboard, mouse, and trackpad controls | Yes | Yes |
| Video and audio filters | Yes | Yes |
| Custom GLSL shaders | Gallery, stacking, presets, and custom files | Custom files, with Anime4K available as a community plugin |
| Plugin system | No | Yes |
| Open source | Bundled libraries are open source; the app is proprietary | Yes, GPL-licensed |
| Intel Mac support | No, Apple Silicon only | Yes |
| Minimum macOS version | macOS 15 | macOS 10.15 for IINA 1.4.4 |

## Features Corvus Player provides as dedicated, integrated tools

### Audio and music

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| AutoEQ database | 6,033 headphone and earphone correction profiles | No dedicated built-in AutoEQ feature found |
| Automatic headphone matching | Applies the matching correction when the audio output changes | No equivalent built-in feature found |
| Per-device EQ memory | Remembers a separate curve for each output device | No equivalent built-in feature found |
| Adjustable EQ band width | Ten bands with gain and width controls plus saveable presets | Ten-band EQ uses fixed-width filters |
| AutoEQ import | Accepts AutoEQ GraphicEQ text | No dedicated importer found |
| Crossfeed | Dedicated adjustable control | Available only through manual mpv or filter configuration |
| Loudness compensation | Dedicated adjustable control | No dedicated built-in control found |
| Night mode | One control compresses loud and quiet passages for late-night viewing | No dedicated built-in mode found |
| Channel tools | Balance and mono fold-down controls | No equivalent dedicated control group found |
| Real-time audio visualizer | Spectrum bars, mirrored bars, waveform, and spectrum curve | No built-in audio visualizer found |
| Synced lyrics | Local LRC files and optional LRClib lookup | No built-in lyrics experience found |
| Interactive lyrics | Active-line highlighting and click-to-seek | No equivalent built-in feature found |

### Streaming

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| yt-dlp lifecycle | Integrated management and settings | Provided through the official Online Media plugin |
| In-player quality switching | Integrated into the playback controls | Available through the official Online Media plugin |
| Browser-cookie authentication | Dedicated Safari, Chrome, and Firefox setting | No equivalent feature documented by the official Online Media plugin |
| SponsorBlock | Converts sponsored segments into chapters | Not documented by IINA or its official Online Media plugin |
| Stream cache presets | Integrated settings and playback presets | Can be configured through mpv options |

### Organization and macOS integration

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| Up Next | Temporary queue that leaves playlist order unchanged | No equivalent built-in queue found |
| Media library | Folder scanning, persistent items, artwork, and playlists | No equivalent built-in library found; a community File Viewer plugin is listed |
| Spotlight library search | Library items are indexed into macOS Spotlight | No Core Spotlight integration found |
| Shortcuts actions | Play or Pause, Seek, Set Speed, and Open File | No App Intents integration found |
| Focus filter | A Focus can automatically enable Night mode | No Focus filter integration found |
| Menu bar mini player | Optional playback controls in the menu bar | No built-in menu bar player found |
| Finder artwork icons | Writes album art or a representative video frame as the file icon | No equivalent built-in feature found |
| Quick Look extensions | Ships preview and thumbnail extensions | Does not ship equivalent extension targets |
| Matroska and WebM Media Extension | Optional system-level preview support for MKV and WebM | No Media Extension target found |

### Subtitles, video, and customization

| Feature | Corvus Player | IINA 1.4.4 |
|---|---|---|
| Subtitle providers | OpenSubtitles and SubDL | OpenSubtitles through an official plugin; no SubDL integration found |
| Curated shader gallery | Anime4K, CAS, adaptive sharpening, and other included choices | Custom shaders are supported; Anime4K is a community plugin |
| Shader stacking | Browse, combine, reorder, and toggle shaders during playback | Advanced shader configuration is available, without an equivalent built-in gallery |
| Playback presets | Named presets coordinate related playback and interface settings | Profiles and mpv configuration are available for advanced users |
| Settings depth | More than 200 options organized and searchable across the app | Searchable Settings with extensive playback options |

## Why Corvus Player feels different

Corvus Player is designed around discovery. Advanced features are presented as named controls, searchable settings, galleries, presets, and contextual explanations. You do not need to know mpv option names or find a plugin before discovering AutoEQ, Night mode, SponsorBlock, lyrics, Finder previews, or macOS automation.

The visual design follows the same idea. Player controls, Music Mode, artwork, Settings, the media library, and utility panels share one hierarchy and interaction language. The result is intentionally richer and more guided than a traditional utility player while remaining native to macOS.

Aesthetics are subjective, and IINA 1.5 is currently in beta with a substantial interface redesign. This comparison therefore avoids claiming that one interface is objectively more attractive. Corvus Player's advantage is the consistency of its integrated experience and the number of advanced features that are visible without extra setup.

## Where IINA may be the better fit

IINA is open source, supports Intel Macs and older macOS versions, offers a JavaScript plugin system, exposes mpv configuration and scripts directly, and currently includes more localization folders. It is a strong choice for users who prioritize open-source development, older hardware support, or extending the player through community plugins.

Corvus Player is a stronger fit for users who want deeper audio tools, a real media library, streaming conveniences, synced lyrics, and broad macOS integration already assembled into one supported application.

## Verification and sources

This comparison was verified on September 7, 2026 against:

- [IINA 1.4.4 source and feature list](https://github.com/iina/iina/tree/v1.4.4)
- [IINA 1.4.4 release](https://github.com/iina/iina/releases/tag/v1.4.4)
- [IINA 1.5.0 beta 1 release notes](https://github.com/iina/iina/releases/tag/v1.5.0-beta1)
- [IINA official Online Media plugin](https://github.com/iina/plugin-online-media)
- [IINA official OpenSubtitles plugin](https://github.com/iina/plugin-opensub)
- [IINA documented plugin list](https://github.com/iina/iina/tree/v1.4.4#iina-plugins-list)
- Corvus Player source, settings index, application targets, bundled resources, and currently published feature list

“No feature found” means that no dedicated implementation was found in IINA 1.4.4, the active IINA development branch, or the documented official plugins under the feature name and related framework symbols. Some results may still be achievable with custom mpv configuration, scripts, or community plugins. The IINA 1.5 stable release should be checked again when it ships.
