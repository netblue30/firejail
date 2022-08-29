# Firejail profile for lbry-viewer
# Description:CLI for searching and playing videos from LBRY, with the Librarian frontend
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include lbry-viewer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/lbry-viewer
noblacklist ${HOME}/.config/lbry-viewer

mkdir ${HOME}/.config/lbry-viewer
mkdir ${HOME}/.cache/lbry-viewer
whitelist ${HOME}/.cache/lbry-viewer
whitelist ${HOME}/.config/lbry-viewer

private-bin gtk-lbry-viewer,lbry-viewer

# Redirect
include youtube-viewers-common.profile
