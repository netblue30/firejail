# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include funnyboat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.funnyboat

include disable-common.inc
include disable-devel.inc
ignore noexec /dev/shm
include disable-exec.inc
include allow-python2.inc
include allow-python3.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
# include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.funnyboat
whitelist ${HOME}/.funnyboat
include whitelist-common.inc
include whitelist-runuser-common.inc
whitelist /usr/share/funnyboat
# Debian:
whitelist /usr/share/games/funnyboat
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
# tracelog

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
