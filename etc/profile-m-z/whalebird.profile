# Firejail profile for whalebird
# Description: Electron-based Mastodon/Pleroma client
# This file is overwritten after every install/update
# Persistent local customizations
include whalebird.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/Whalebird

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Whalebird
whitelist ${HOME}/.config/Whalebird
include whitelist-common.inc
include whitelist-var-common.inc

no3d
nou2f
novideo
protocol unix,inet,inet6
shell none

disable-mnt
private-bin whalebird
private-cache
private-dev
private-etc fonts,machine-id
private-tmp

# Redirect
include electron.profile
