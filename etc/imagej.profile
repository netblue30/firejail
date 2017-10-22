# Firejail profile for imagej
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/imagej.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/.imagej

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
net none
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

private-bin imagej,bash,grep,sort,tail,tr,cut,whoami,hostname,uname,mkdir,ls,touch,free,awk,update-java-alternatives,basename,xprop,rm,ln
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
