<div align="center">

<img src="https://corvusdevs.github.io/Corvus-Player/icon.png" width="200" height="200" alt="Corvus Player icon">

# Corvus Player

**The most powerful and customizable media player for macOS**

<p>
  <img src="https://img.shields.io/github/v/release/CorvusDevs/Corvus-Player?style=flat-square&color=2d7ff9&label=release" alt="Latest release">
  <img src="https://img.shields.io/github/downloads/CorvusDevs/Corvus-Player/total?style=flat-square&color=4CAF50&label=downloads" alt="Total downloads">
  <img src="https://img.shields.io/badge/macOS-14.0+-000000?style=flat-square&logo=apple&logoColor=white" alt="macOS 14.0+">
  <img src="https://img.shields.io/badge/Apple%20Silicon%20%2B%20Intel-supported-444?style=flat-square" alt="Apple Silicon + Intel">
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

Built on **mpv** with a native **SwiftUI** interface. GPU-accelerated playback, real-time GLSL shaders, full streaming via yt-dlp, 200+ settings, and zero tracking. Free forever, with an optional Pro upgrade.

## Contents

- [Features](#features)
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
- **Best-in-class subtitles.** Auto-load, online search via OpenSubtitles, SDH support, dual tracks, full ASS/SSA styling.
- **Music mode.** Dedicated UI with album art display, audio visualizer, gapless playback, ReplayGain.
- **Synced lyrics.** Karaoke-style, time-synced lyrics in music mode. Fetched automatically from LRClib or loaded from local .lrc files, with the active line highlighted and click-to-jump on any line.
- **Playlists & library.** Drag-and-drop playlists with thumbnails, media library with folder scanning, session persistence.
- **Picture-in-picture.** Compact floating mini player that stays on top.
- **Seekbar thumbnails.** Hover over the seekbar to preview frames at any moment.
- **Album art & video previews in Finder.** Every song and video gets real album art (audio) or a representative video frame (video) as its Finder icon. Works for MKV, WebM, Opus, OGG, FLAC, DSD, and 20+ formats macOS normally shows as a generic music note or filmstrip. Quick Look preview works too.
- **Chapter navigation.** Full support for video chapters with quick navigation. MKV chapters, YouTube chapters, SponsorBlock segments.
- **Smart shortcuts.** Customizable keyboard shortcuts plus trackpad gestures. Pinch to zoom, swipe to seek, two-finger tap to pause.
- **mpv under the hood.** Built on libmpv for battle-tested, high-performance media playback.
- **Truly native macOS.** SwiftUI + AppKit, not an Electron wrapper. Quick Look extensions, Dock menus, system integration that feels Apple-built.
- **36 languages.** Fully localized with searchable settings in every language. RTL support for Arabic and Hebrew.

## What makes Corvus Player special

🎨 **A built-in GLSL shader gallery.** Browse, stack, and toggle shaders in real time. Anime4K upscaling, adaptive sharpening, CAS, custom presets. The whole library is one click away during playback.

🖼️ **Universal Finder thumbnails.** Every song and video shows real album art or a representative video frame as its Finder icon, including the formats macOS normally renders as a generic music note or filmstrip (MKV, WebM, Opus, OGG, FLAC, DSD, and 20+ more). Quick Look previews work too. A background helper keeps thumbnails fresh even when Corvus Player is fully closed.

🔍 **Settings you can actually find.** Searchable across every tab, with deep-linking from quick-action prompts. 200+ options, but you'll never have to hunt for them.

🌐 **36 languages, fully translated.** Including the searchable settings and onboarding. RTL layout flip for Arabic and Hebrew. The language picker is one click away.

⚡ **GPU-accelerated playback on Apple Silicon.** Built on mpv with VideoToolbox decoding and Metal rendering. 4K HDR plays smoothly; the CVDisplayLink-driven render loop keeps frame pacing rock-solid even during fullscreen transitions.

🎵 **A real music mode, not an afterthought.** Album art display, audio visualizer, gapless playback, ReplayGain, compact floating mini player. Works as your media library and your music player.

🎬 **Streaming without the browser.** Paste any URL: YouTube, Twitch, SoundCloud, hundreds of sites via yt-dlp. SponsorBlock, browser-cookie auth, quality switcher, subtitle fetching all built in.

🛡️ **Built for privacy.** Zero accounts, zero telemetry, zero analytics. License validation happens locally against a Keychain-stored key. The only network calls Corvus Player makes are the ones you ask for.

## Built with

**mpv** · **SwiftUI** · **AppKit** · **Metal** · **VideoToolbox** · **yt-dlp** · **Sparkle** · **OpenSubtitles**

## Privacy

Free forever. No accounts, no analytics, no telemetry, no tracking. Corvus Player makes zero network requests unless you're streaming. License validation happens locally against a Keychain-stored key; no phone-home.

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
