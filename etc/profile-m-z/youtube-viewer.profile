# Firejail profile for youtube-viewer
# Description: Trizen's CLI Youtube viewer with login support
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include youtube-viewer.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/youtube-viewer
nodeny  ${HOME}/.config/youtube-viewer

mkdir ${HOME}/.cache/youtube-viewer
mkdir ${HOME}/.config/youtube-viewer
allow  ${HOME}/.cache/youtube-viewer
allow  ${HOME}/.config/youtube-viewer

private-bin gtk-youtube-viewer,gtk2-youtube-viewer,gtk3-youtube-viewer,youtube-viewer

# Redirect
include youtube-viewers-common.profile