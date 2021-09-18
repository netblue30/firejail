# Firejail profile for whalebird
# Description: Electron-based Mastodon/Pleroma client
# This file is overwritten after every install/update
# Persistent local customizations
include whalebird.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/Whalebird

mkdir ${HOME}/.config/Whalebird
whitelist ${HOME}/.config/Whalebird

no3d

private-bin electron,electron[0-9],electron[0-9][0-9],whalebird
private-etc fonts,ld.so.preload,machine-id

# Redirect
include electron.profile
