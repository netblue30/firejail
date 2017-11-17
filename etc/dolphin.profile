# Firejail profile for dolphin
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dolphin.local
# Persistent global definitions
include /etc/firejail/globals.local

# warning: firejail is currently not effectively constraining dolphin since used services are started by kdeinit5

noblacklist ${HOME}/.local/share/Trash
# noblacklist ${HOME}/.config/dolphinrc - diable-programs.inc is disabled, see below
# noblacklist ${HOME}/.local/share/dolphin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
# dolphin needs to be able to start arbitrary applications so we cannot blacklist their files
# include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none

# private-bin
# private-dev
# private-etc
# private-tmp
