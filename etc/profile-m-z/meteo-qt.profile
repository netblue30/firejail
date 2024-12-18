# Firejail profile for meteo-qt
# Description: System tray application for weather status information
# This file is overwritten after every install/update
# Persistent local customizations
include meteo-qt.local
# Persistent global definitions
include globals.local

# To allow the program to autostart, add the following to meteo-qt.local:
# Warning: This allows the program to easily escape the sandbox.
#noblacklist ${HOME}/.config/autostart
#whitelist ${HOME}/.config/autostart

noblacklist ${HOME}/.config/meteo-qt

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/meteo-qt
whitelist ${HOME}/.config/meteo-qt
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin meteo-qt,python*
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
