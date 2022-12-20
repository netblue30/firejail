# Firejail profile for zart
# Description: A GUI for G'MIC real-time manipulations on the output of a webcam
# This file is overwritten after every install/update
# Persistent local customizations
include zart.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp

private-bin ffmpeg,ffplay,ffprobe,melt,zart
private-dev

dbus-user none
dbus-system none

restrict-namespaces
