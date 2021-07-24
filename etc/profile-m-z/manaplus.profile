# Firejail profile for manaplus
# Description: 2D MMORPG client for Evol Online and The Mana World
# This file is overwritten after every install/update
# Persistent local customizations
include manaplus.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/mana
nodeny  ${HOME}/.local/share/mana

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/mana
mkdir ${HOME}/.config/mana/mana
mkdir ${HOME}/.local/share/mana
allow  ${HOME}/.config/mana
allow  ${HOME}/.local/share/mana
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
private-bin manaplus
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
