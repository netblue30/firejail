# Firejail profile for scorched3d-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include scorched3d-wrapper.local

include allow-opengl-game.inc

private-bin scorched3d-wrapper

# Redirect
include scorched3d.profile
