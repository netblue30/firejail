# Firejail profile for skypeforlinux
# This file is overwritten after every install/update
# Persistent local customizations
include skypeforlinux.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/skypeforlinux

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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
private-cache
# private-dev - needs /dev/disk
private-tmp

noexec ${HOME}
# noexec /tmp  - breaks Skype
