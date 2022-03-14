# Firejail profile for mupdf-gl
# Description: Lightweight PDF viewer
# This file is overwritten after every install/update
# Persistent local customizations
include mupdf-gl.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/mupdf.history
noblacklist ${HOME}/.mupdf.history

ignore no3d

# Redirect
include mupdf.profile
