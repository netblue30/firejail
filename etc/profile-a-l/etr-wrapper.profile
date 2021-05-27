# Firejail profile for etr-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include etr-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

include allow-opengl-game.inc

private-bin etr-wrapper

# Redirect
include etr.profile
