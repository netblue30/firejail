# Firejail profile for ffmpegthumbnailer
# Description: FFmpeg-based video thumbnailer
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ffmpegthumbnailer.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin ffmpegthumbnailer
private-lib libffmpegthumbnailer.so.*

# fix for ranger video thumbnails
ignore private-cache

# Redirect
include ffmpeg.profile
