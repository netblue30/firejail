# Firejail profile for qemu-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qemu-launcher.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.qemu-launcher

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-tmp

noexec /tmp
