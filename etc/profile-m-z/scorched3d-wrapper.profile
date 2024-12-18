# Firejail profile for scorched3d-wrapper
# This file is overwritten after every install/update
# Persistent local customizations
include scorched3d-wrapper.local

# Allow opengl-game wrapper script (distribution-specific)
include allow-opengl-game.inc

private-bin scorched3d-wrapper

# Redirect
include scorched3d.profile
