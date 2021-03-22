# Firejail profile for pipe-viewer
# Description: Fork of youtube-viewer, scrapes youtube directly and with invidious
# This file is overwritten after every install/update
# Persistent local customizations
include pipe-viewer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/pipe-viewer
noblacklist ${HOME}/.config/pipe-viewer

mkdir ${HOME}/.config/pipe-viewer
mkdir ${HOME}/.cache/pipe-viewer
whitelist ${HOME}/.cache/pipe-viewer
whitelist ${HOME}/.config/pipe-viewer

private-bin gtk-pipe-viewer,pipe-viewer

# Redirect
include youtube-viewers-common.profile
