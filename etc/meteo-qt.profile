# Firejail profile for meteo-qt
# Description: System tray application for weather status information
# This file is overwritten after every install/update
# Persistent local customizations
include meteo-qt.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/autostart
noblacklist ${HOME}/.config/meteo-qt

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.config/autostart
mkdir ${HOME}/.config/meteo-qt
whitelist ${HOME}/.config/meteo-qt
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin meteo-qt,python*
private-cache
private-dev
private-tmp

memory-deny-write-execute
