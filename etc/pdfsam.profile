# Firejail profile for pdfsam
# Description: PDF Split and Merge
# This file is overwritten after every install/update
# Persistent local customizations
include pdfsam.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.java
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
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-bin pdfsam,sh,bash,java,archlinux-java,grep,awk,dirname,uname,which,sort,find,readlink,expr,ls,java-config
private-cache
private-dev
private-tmp

