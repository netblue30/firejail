# Firejail profile for electrum
# Description: Lightweight Bitcoin wallet
# This file is overwritten after every install/update
# Persistent local customizations
include electrum.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.electrum

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.electrum
whitelist ${HOME}/.electrum
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
private-bin electrum,python*
private-cache
?HAS_APPIMAGE: ignore private-dev
private-dev
private-etc @tls-ca,@x11
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
