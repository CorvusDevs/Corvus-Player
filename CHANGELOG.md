# Changelog

## v1.8.0-b1

### Streaming (yt-dlp)
- Full yt-dlp integration: paste URLs to play video or audio from YouTube, SoundCloud, and hundreds of sites
- Quality switcher on the control bar — select resolution on the fly without restarting playback
- Cookies from browser support (Chrome, Firefox, Brave) for age-gated/private content
- Safari cookie sandbox warning — recommends Chrome or Firefox
- Deno detection and install guidance for YouTube signature solving
- Geo-bypass, rate limiting, and SponsorBlock options
- Stream subtitle download with language priority picker and format conversion
- Raw yt-dlp options text field in Advanced settings for power users
- Audio-only site detection — hides "Play Video" button for sites like SoundCloud
- Stream thumbnail display in player for audio-only content
- PATH setup for Homebrew tools (deno, yt-dlp) in both subprocesses and mpv's ytdl_hook
- Streaming settings apply live without restart

### Player
- Loading/buffering spinner shown during seeks, cache pauses, and file loads
- Fullscreen top bar with hover trigger zone for title and controls
- Subtitle margin adjustment when controls are visible
- Window resize-to-video aspect ratio option
- Open in fullscreen option
- Remember window size between launches
- Title bar style setting (normal, transparent, hidden)

### Mini Player & Music Mode
- New mini player mode with compact controls
- Album art display for audio files
- Music mode with dedicated layout

### Playlist
- Detachable playlist panel (floating NSPanel)
- Show playlist on launch option
- Enhanced playlist management

### Media Library
- New media library sidebar view

### Stats Overlay
- Real-time video stats overlay (resolution, codec, FPS, bitrate, cache)

### Shader Gallery
- Browse and apply video shaders from a curated gallery

### Onboarding
- First-launch persona selection with 6 community presets (Anime, Cinema, Home Theater, Performance, Streaming, Music)

### Settings
- Full settings search with fuzzy matching across all tabs and options
- New tabs: Streaming, Mini Player, Input
- Merged Hotkeys and Gestures into unified Input tab
- Screenshot settings (format, quality, directory, template, clipboard copy)
- Scaling filter controls (upscale, downscale, chroma) with anti-ringing
- Subtitle styling: font family picker, border style, blur, shadow, margin controls
- ASS subtitle override, blend subtitles, fix timing, MKV preroll options
- Preferred subtitle language picker (matching movie settings pattern)
- Community and user preset management improvements
- Raw mpv options conflict detection

### Subtitle Search
- OpenSubtitles integration improvements

### Under the Hood
- Fixed `reset-on-next-file` to use specific option list instead of `all` (prevents ytdl-format reset)
- Deduplication of ytdl-raw-options to prevent log spam from syncSettings
- yt-dlp error message cleanup with actionable hints
- Improved thumbnail generation reliability
- File settings store enhancements

## v1.5.0-b2

### Seamless Fullscreen
- Replaced macOS native fullscreen with borderless fullscreen for instant, lag-free transitions
- Display link stays alive across window changes — no more teardown/recreation
- Display link retargets to current screen when window moves between displays

### Thumbnail Generation
- Two-phase generation: coarse pass (~34 thumbnails at 75s intervals) loads in ~2.8s, fine pass fills remaining in background
- 16-way parallel ffmpeg keyframe seeking for fast generation
- Playback starts immediately — thumbnails generate silently in the background
- Removed pre-playback loading screen; no more waiting before video plays
- Single continuous progress tracking across both phases
- Fixed coarse/fine overlap bug causing duplicate thumbnails

### Rendering Pipeline
- Simplified CAOpenGLLayer architecture — no suspend/resume, continuous rendering
- Background-thread rendering via dedicated `renderQueue` for jitter-free playback

## v1.5.0-b1

### Rendering
- Rewrote video rendering with CAOpenGLLayer (off-main-thread, vsync-aware)
- CVDisplayLink for frame timing with `mpv_render_context_report_swap`
- Advanced control for precise frame scheduling
- Fixed FBO handling — query `GL_FRAMEBUFFER_BINDING` instead of hardcoding

### Performance
- Added dedicated Performance settings tab
- IINA-inspired mpv options: hr-seek, demuxer buffers, cache, input isolation
- Configurable read-ahead buffer (default 150 MiB) and back buffer (75 MiB)

### Seek Bar
- Bookmark labels shown in thumbnail panel on hover (bypasses SwiftUI Slider hit testing)
- Smooth thumbnail panel tracking with decoupled image updates
- Removed 150ms throttle on hover position updates
