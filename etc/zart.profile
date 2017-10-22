# Firejail profile for zart
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/zart.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

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
notv
protocol unix
seccomp
shell none

private-bin zart,ffmpeg,melt,ffprobe,ffplay
private-dev

noexec ${HOME}
noexec /tmp
