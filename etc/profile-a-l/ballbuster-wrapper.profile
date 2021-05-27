# Firejail profile for ballbuster-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include ballbuster-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

include allow-opengl-game.inc

private-bin ballbuster-wrapper

# Redirect
include ballbuster.profile
