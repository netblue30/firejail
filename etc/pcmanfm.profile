# Firejail profile for pcmanfm
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pcmanfm.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/Trash
noblacklist ~/.config/libfm
noblacklist ~/.config/pcmanfm

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
# include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
nonewprivs
noroot
nosound
novideo
protocol unix
seccomp
shell none
tracelog
