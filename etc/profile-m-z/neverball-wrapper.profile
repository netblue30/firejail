# Firejail profile for neverball-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include neverball-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow opengl-game wrapper script (distribution-specific)
include allow-opengl-game.inc

private-bin neverball-wrapper

# Redirect
include neverball.profile
