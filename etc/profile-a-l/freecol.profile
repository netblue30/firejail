# Firejail profile for freecol
# Description: Turn-based multi-player strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include freecol.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.freecol
noblacklist ${HOME}/.cache/freecol
noblacklist ${HOME}/.config/freecol
noblacklist ${HOME}/.local/share/freecol

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.java
mkdir ${HOME}/.cache/freecol
mkdir ${HOME}/.config/freecol
mkdir ${HOME}/.local/share/freecol
whitelist ${HOME}/.freecol
whitelist ${HOME}/.java
whitelist ${HOME}/.cache/freecol
whitelist ${HOME}/.config/freecol
whitelist ${HOME}/.local/share/freecol
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
