# Firejail profile for simplescreenrecorder
# Description: A feature-rich screen recorder that supports X11 and OpenGL
# This file is overwritten after every install/update
# Persistent local customizations
include simplescreenrecorder.local
# Persistent global definitions
include globals.local

noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp
shell none
tracelog

private-cache
private-dev
# private-etc alternatives
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
