# Firejail profile for ffplay
# Description: FFmpeg-based media player
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ffplay.local
# Persistent global definitions
# added by included profile
#include globals.local

protocol inet,inet6,unix
ignore ipc-namespace
ignore nogroups
ignore nosound

private-bin ffplay
private-etc alsa,asound.conf,group

# Redirect
include ffmpeg.profile
