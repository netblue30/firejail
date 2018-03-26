# Firejail profile for gnome-ring
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-ring.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/gnome-ring

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
# private-dev
private-tmp

noexec ${HOME}
noexec /tmp
