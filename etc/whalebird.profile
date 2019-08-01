# Firejail profile for whalebird
# Description: Electron-based Mastodon/Pleroma client
# This file is overwritten after every install/update
# Persistent local customizations
include whalebird.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Whalebird

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Whalebird
whitelist ${HOME}/.config/Whalebird
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin whalebird
private-cache
private-dev
private-etc fonts,machine-id
private-tmp
