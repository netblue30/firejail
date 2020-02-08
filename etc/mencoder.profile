# Firejail profile for mencoder
# Description: Free command line video decoding, encoding and filtering tool
# This file is overwritten after every install/update
# Persistent local customizations
include mencoder.local
# Persistent global definitions
# added by included profile
#include globals.local

# added by included profile
#include disable-common.inc
#include disable-devel.inc
#include disable-interpreters.inc
#include disable-passwdmgr.inc
#include disable-programs.inc

ipc-namespace
machine-id
net none
no3d
nodbus
nosound
notv
nou2f
protocol unix
seccomp
shell none
tracelog
x11 none

private-bin mencoder

memory-deny-write-execute

# Redirect
include mplayer.profile
