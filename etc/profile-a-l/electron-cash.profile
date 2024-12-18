# Firejail profile for electron-cash
# Description: Lightweight Bitcoin Cash wallet
# This file is overwritten after every install/update
# Persistent local customizations
include electron-cash.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.electron-cash

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.electron-cash
whitelist ${HOME}/.electron-cash
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
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

disable-mnt
private-bin electron-cash,python*
private-cache
?HAS_APPIMAGE: ignore private-dev
private-dev
private-etc @network,@tls-ca,@x11
private-tmp

# dbus-user none
# dbus-system none

restrict-namespaces
