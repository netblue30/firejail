# Firejail profile for etr-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include etr-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow opengl-game wrapper script (distribution-specific)
include allow-opengl-game.inc

private-bin etr-wrapper

# Redirect
include etr.profile
