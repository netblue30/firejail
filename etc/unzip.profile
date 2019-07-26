# Firejail profile for unzip
# Description: De-archiver for .zip files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include unzip.local
# Persistent global definitions
include globals.local

# GNOME Shell integration (chrome-gnome-shell)
noblacklist ${HOME}/.local/share/gnome-shell

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
hostname unzip
ipc-namespace
machine-id
net none
no3d
nodbus
nodvd
#nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

private-bin unzip
private-dev
private-etc alternatives,group,localtime,passwd
