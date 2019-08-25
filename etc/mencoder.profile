# Firejail profile for mencoder
# Description: Free command line video decoding, encoding and filtering tool
# This file is overwritten after every install/update
# Persistent local customizations
include mencoder.local
# Persistent global definitions
# added by included profile
#include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

net none
no3d
nodbus
nosound
notv
nou2f
protocol unix
seccomp
shell none

private-bin mencoder

# Redirect
include mplayer.profile
