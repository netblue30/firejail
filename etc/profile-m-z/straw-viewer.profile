# Firejail profile for straw-viewer
# Description: Fork of youtube-viewer acts like an invidious frontend
# This file is overwritten after every install/update
# Persistent local customizations
include straw-viewer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/straw-viewer
noblacklist ${HOME}/.config/straw-viewer

mkdir ${HOME}/.config/straw-viewer
mkdir ${HOME}/.cache/straw-viewer
whitelist ${HOME}/.cache/straw-viewer
whitelist ${HOME}/.config/straw-viewer

private-bin gtk-straw-viewer,straw-viewer

# Redirect
include youtube-viewers-common.profile
