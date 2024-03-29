# Firejail profile for gl-117-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include gl-117-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow opengl-game wrapper script (distribution-specific)
include allow-opengl-game.inc

private-bin gl-117-wrapper

# Redirect
include gl-117.profile
