# Firejail profile for dolphin
# Description: File manager
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dolphin.local
# Persistent global definitions
include /etc/firejail/globals.local

# warning: firejail is currently not effectively constraining dolphin since used services are started by kdeinit5

noblacklist ${HOME}/.local/share/Trash
# noblacklist ${HOME}/.cache/dolphin - disable-programs.inc is disabled, see below
# noblacklist ${HOME}/.config/dolphinrc
# noblacklist ${HOME}/.local/share/dolphin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
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

# private-dev
# private-tmp

join-or-start dolphin
