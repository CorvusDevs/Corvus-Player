# Changelog

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
