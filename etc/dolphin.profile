# Firejail profile for dolphin
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dolphin.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/Trash
noblacklist ~/.config/dolphinrc
noblacklist ~/.local/share/dolphin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
# include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix
seccomp
shell none

# private-bin
# private-dev
# private-etc
# private-tmp

# CLOBBERED COMMENTS
# dolphin needs to be able to start arbitrary applications so we cannot blacklist their files
# warning: firejail is currently not effectively constraining dolphin since used services are started by kdeinit5
