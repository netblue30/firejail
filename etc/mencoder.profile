# Firejail profile for mencoder
# Description: Free command line video decoding, encoding and filtering tool
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mencoder.local
# Persistent global definitions
# added by included profile
#include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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

include /etc/firejail/mplayer.profile
