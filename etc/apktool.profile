# Firejail profile for apktool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/apktool.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
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

private-bin apktool,bash,dash,java,dirname,basename,expr,sh
private-dev

noexec ${HOME}
noexec /tmp
