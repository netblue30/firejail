# Firejail profile for qt-faststart
# Description: FFmpeg-based media utility
# This file is overwritten after every install/update
# Persistent local customizations
include qt-faststart.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin qt-faststart

# Redirect
include ffmpeg.profile
