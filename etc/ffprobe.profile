# Firejail profile for ffprobe
# Description: FFmpeg-based media prober
# This file is overwritten after every install/update
# Persistent local customizations
include ffprobe.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin ffprobe

# Redirect
include ffmpeg.profile
