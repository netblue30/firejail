# Firejail profile for songrec
# Description: An open-source Shazam client for Linux
# This file is overwritten after every install/update
# Persistent local customizations
include songrec.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-common.inc
include whitelist-player-common.inc

apparmor
caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none

disable-mnt
private-bin songrec,ffmpeg
private-dev
private-tmp

dbus-user none
dbus-system none
