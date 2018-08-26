# Firejail profile for apktool
# Description: Tool for reverse engineering Android apk files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/apktool.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
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

private-bin apktool,bash,java,dirname,basename,expr,sh
private-cache
private-dev

noexec ${HOME}
noexec /tmp
