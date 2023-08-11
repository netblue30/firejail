# Firejail profile for asounder
# Description: Graphical audio CD ripper and encoder
# This file is overwritten after every install/update
# Persistent local customizations
include asunder.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/asunder
noblacklist ${HOME}/.asunder_album_genre
noblacklist ${HOME}/.asunder_album_title
noblacklist ${HOME}/.asunder_album_artist
noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
#nogroups
noinput
nonewprivs
noroot
nou2f
notv
novideo
protocol unix,inet,inet6
seccomp

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

# mdwe is disabled due to breaking hardware accelerated decoding
#memory-deny-write-execute
restrict-namespaces
