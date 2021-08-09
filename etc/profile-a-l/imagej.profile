# Firejail profile for imagej
# Description: Image processing program with a focus on microscopy images
# This file is overwritten after every install/update
# Persistent local customizations
include imagej.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.imagej

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-bin awk,basename,bash,cut,free,grep,hostname,imagej,ln,ls,mkdir,rm,sort,tail,touch,tr,uname,update-java-alternatives,whoami,xprop
private-dev
private-tmp

dbus-user none
dbus-system none
