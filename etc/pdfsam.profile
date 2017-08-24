# Firejail profile for pdfsam
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pdfsam.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
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

private-bin pdfsam,dash,sh,bash,java,archlinux-java,grep,awk,dirname,uname,which,sort,find,readlink,expr,ls,java-config
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
