# Firejail profile for deadbeef
# Description: A GTK+ audio player for GNU/Linux
# This file is overwritten after every install/update
# Persistent local customizations
include deadbeef.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/deadbeef
nodeny  ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

