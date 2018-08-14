# Firejail profile for zart
# Description: A GUI for G'MIC real-time manipulations on the output of a webcam
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/zart.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
ipc-namespace
net none
nodbus
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
