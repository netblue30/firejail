# Firejail profile for skypeforlinux
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/skypeforlinux.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/skypeforlinux

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
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
# private-dev - needs /dev/disk
private-tmp

noexec ${HOME}
noexec /tmp
