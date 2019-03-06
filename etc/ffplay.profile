# Firejail profile for ffplay
# Description: FFmpeg-based media player
# This file is overwritten after every install/update
# Persistent local customizations
include ffplay.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin ffplay


# Redirect
include ffmpeg.profile
