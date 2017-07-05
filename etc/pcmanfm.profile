# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/pcmanfm.local

noblacklist ~/.config/pcmanfm
noblacklist ~/.config/libfm
noblacklist ${HOME}/.local/share/Trash

include /etc/firejail/disable-common.inc
#include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
no3d
nonewprivs
noroot
nosound
novideo
protocol unix
seccomp
shell none
tracelog
