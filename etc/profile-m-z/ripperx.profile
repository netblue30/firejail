# Firejail profile for mpv
# Description: Graphical audio CD ripper and encoder
# This file is overwritten after every install/update
# Persistent local customizations
include ripperx.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.ripperXrc
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
nogroups
noinput
nonewprivs
noroot
nou2f
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
