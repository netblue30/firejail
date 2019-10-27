# Firejail profile for dolphin
# Description: File manager
# This file is overwritten after every install/update
# Persistent local customizations
include dolphin.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/Trash
# noblacklist ${HOME}/.cache/dolphin - disable-programs.inc is disabled, see below
# noblacklist ${HOME}/.config/dolphinrc
# noblacklist ${HOME}/.local/share/dolphin

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# dolphin needs to be able to start arbitrary applications so we cannot blacklist their files
# include disable-programs.inc

allusers
caps.drop all
# net none
netfilter
nodvd
nogroups
nonewprivs
# Comment the next line (or put 'ignore noroot' in your dolphin.local) if you use MPV+Vulkan (see issue #3012)
noroot
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
# private-tmp

join-or-start dolphin
