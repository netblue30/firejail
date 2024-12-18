# Firejail profile for neverputt-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include neverputt-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow opengl-game wrapper script (distribution-specific)
include allow-opengl-game.inc

private-bin neverputt-wrapper

# Redirect
include neverputt.profile
