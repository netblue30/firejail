# Firejail profile for colorful-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include colorful-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow opengl-game wrapper script (distribution-specific)
include allow-opengl-game.inc

private-bin colorful-wrapper

# Redirect
include colorful.profile
