# Firejail profile for minetest
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/minetest.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.minetest

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.minetest
whitelist ${HOME}/.minetest
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin minetest
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
