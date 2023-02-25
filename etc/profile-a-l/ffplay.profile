# Firejail profile for ffplay
# Description: FFmpeg-based media player
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ffplay.local
# Persistent global definitions
# added by included profile
#include globals.local

protocol unix,inet,inet6
ignore ipc-namespace
ignore nogroups
ignore nosound

private-bin ffplay
private-etc

# Redirect
include ffmpeg.profile
