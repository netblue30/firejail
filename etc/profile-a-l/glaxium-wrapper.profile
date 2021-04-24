# Firejail profile for glaxium-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include glaxium-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

include allow-opengl-game.inc

private-bin glaxium-wrapper

# Redirect
include glaxium.profile
