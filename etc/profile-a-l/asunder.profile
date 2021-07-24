# Firejail profile for asounder
# Description: Graphical audio CD ripper and encoder
# This file is overwritten after every install/update
# Persistent local customizations
include asunder.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/asunder
nodeny  ${HOME}/.asunder_album_genre
nodeny  ${HOME}/.asunder_album_title
nodeny  ${HOME}/.asunder_album_artist
nodeny  ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
# nogroups
noinput
nonewprivs
noroot
nou2f
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

# mdwe is disabled due to breaking hardware accelerated decoding
# memory-deny-write-execute
