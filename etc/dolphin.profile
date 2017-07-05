# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/dolphin.local

# dolphin profile

# warning: firejail is currently not effectively constraining dolphin since used services are started by kdeinit5

noblacklist ~/.config/dolphinrc
noblacklist ~/.local/share/dolphin
noblacklist ~/.kde4/share/kde4/services
noblacklist ~/.kde/share/kde4/services
noblacklist ${HOME}/.local/share/Trash

include /etc/firejail/disable-common.inc
# dolphin needs to be able to start arbitrary applications so we cannot blacklist their files
#include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
shell none
seccomp
protocol unix

# private-bin
# private-dev
# private-tmp
# private-etc
