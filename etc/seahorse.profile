# Firejail profile for seahorse
# Description: GNOME application for managing PGP keys
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse.local
# Persistent global definitions
include globals.local

# dconf
mkdir ${HOME}/.config/dconf
noblacklist ${HOME}/.config/dconf
whitelist ${HOME}/.config/dconf

# gpg
mkdir ${HOME}/.gnupg
noblacklist ${HOME}/.gnupg
whitelist ${HOME}/.gnupg

# ssh
whitelist /etc/ld.so.preload
noblacklist /etc/ssh
whitelist /etc/ssh
noblacklist /tmp/ssh-*
whitelist /tmp/ssh-*
mkdir ${HOME}/.ssh
noblacklist ${HOME}/.ssh
whitelist ${HOME}/.ssh

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc
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
# shell none - causes gpg to hang
tracelog

disable-mnt
private-cache
private-dev

writable-run-user
