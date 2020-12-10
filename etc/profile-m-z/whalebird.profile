# Firejail profile for whalebird
# Description: Electron-based Mastodon/Pleroma client
# This file is overwritten after every install/update
# Persistent local customizations
include whalebird.local
# Persistent global definitions
include globals.local

ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/Whalebird

mkdir ${HOME}/.config/Whalebird
whitelist ${HOME}/.config/Whalebird
include whitelist-var-common.inc

no3d

disable-mnt
private-bin whalebird
private-cache
private-dev
private-etc fonts,machine-id
private-tmp

# Redirect
include electron.profile
