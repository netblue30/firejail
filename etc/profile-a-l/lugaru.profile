# Firejail profile for lugaru
# Description: Ninja rabbit fighting game
# This file is overwritten after every install/update
# Persistent local customizations
include lugaru.local
# Persistent global definitions
include globals.local

# note: crashes after entering

noblacklist ${HOME}/.config/lugaru
noblacklist ${HOME}/.local/share/lugaru

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/lugaru
mkdir ${HOME}/.local/share/lugaru
whitelist ${HOME}/.config/lugaru
whitelist ${HOME}/.local/share/lugaru
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin lugaru
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
