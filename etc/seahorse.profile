# Firejail profile for seahorse
# Description: GNOME application for managing PGP keys
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/dconf
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.ssh
noblacklist /etc/ssh
noblacklist /tmp/ssh-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/dconf
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.ssh
whitelist ${HOME}/.config/dconf
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.ssh
whitelist /etc/ld.so.preload
whitelist /etc/ssh
whitelist /tmp/ssh-*
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
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
private-cache
private-dev

writable-run-user
