# Firejail profile for warsow
# Description: Fast paced 3D first person shooter
# This file is overwritten after every install/update
# Persistent local customizations
include warsow.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.cache/warsow-2.1
noblacklist ${HOME}/.local/share/warsow-2.1

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/warsow-2.1
mkdir ${HOME}/.local/share/warsow-2.1
whitelist ${HOME}/.cache/warsow-2.1
whitelist ${HOME}/.local/share/warsow-2.1
whitelist /usr/share/warsow
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin basename,bash,dirname,sed,sh,uname,warsow
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
