# Firejail profile for xzdec
# Description: XZ-format compression utilities - tiny decompressors
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include xzdec.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
ipc-namespace
machine-id
net none
no3d
nodbus
nodvd
#nogroups
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

private-dev
