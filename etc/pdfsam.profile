# Firejail profile for pdfsam
# Description: PDF Split and Merge
# This file is overwritten after every install/update
# Persistent local customizations
include pdfsam.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.java
noblacklist ${DOCUMENTS}

# Allow access to java
noblacklist ${PATH}/java
noblacklist /usr/lib/java
noblacklist /etc/java
noblacklist /usr/share/java

include disable-common.inc
include disable-devel.inc
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

noexec ${HOME}
noexec /tmp
