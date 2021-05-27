# Firejail profile for youtube-viewer
# Description: Trizen's CLI Youtube viewer with login support
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include youtube-viewer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/youtube-viewer
noblacklist ${HOME}/.config/youtube-viewer

mkdir ${HOME}/.cache/youtube-viewer
mkdir ${HOME}/.config/youtube-viewer
whitelist ${HOME}/.cache/youtube-viewer
whitelist ${HOME}/.config/youtube-viewer

private-bin gtk-youtube-viewer,gtk2-youtube-viewer,gtk3-youtube-viewer,youtube-viewer

# Redirect
include youtube-viewers-common.profile