# Firejail profile for ffprobe
# Description: FFmpeg-based media prober
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ffprobe.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore private-bin

# Redirect
include ffmpeg.profile
