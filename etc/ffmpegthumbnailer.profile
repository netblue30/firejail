# Firejail profile for ffmpegthumbnailer
# Description: FFmpeg-based video thumbnailer
# This file is overwritten after every install/update
# Persistent local customizations
include ffmpegthumbnailer.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin ffmpegthumbnailer
private-lib libffmpegthumbnailer.so.*


# Redirect
include ffmpeg.profile
