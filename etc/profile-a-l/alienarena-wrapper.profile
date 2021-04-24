# Firejail profile for alienarena-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include alienarena-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

include allow-opengl-game.inc

private-bin alienarena-wrapper

# Redirect
include alienarena.profile
