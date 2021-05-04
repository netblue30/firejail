# Firejail profile for pdfsam
# Description: PDF Split and Merge
# This file is overwritten after every install/update
# Persistent local customizations
include pdfsam.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-bin archlinux-java,awk,bash,dirname,expr,find,grep,java,java-config,ls,pdfsam,readlink,sh,sort,uname,which
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
