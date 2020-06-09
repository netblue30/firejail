# Firejail profile for scorched3d
# This file is overwritten after every install/update
# Persistent local customizations
include scorched3d-wrapper.local

whitelist /usr/share/opengl-games-utils
private-bin basename,bash,cut,glxinfo,grep,head,sed,zenity

# Redirect
include scorched3d.profile
