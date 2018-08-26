# Firejail profile for pdfsam
# Description: PDF Split and Merge
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pdfsam.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java
noblacklist ${DOCUMENTS}

# Allow access to java
noblacklist ${PATH}/java
noblacklist /usr/lib/java
noblacklist /etc/java
noblacklist /usr/share/java

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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
