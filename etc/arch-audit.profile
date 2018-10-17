# Firejail profile for arch-audit
# Description: A utility like pkg-audit based on Arch CVE Monitoring Team data
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include arch-audit.local
# Persistent global definitions
include globals.local


noblacklist /var/lib/pacman

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
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

disable-mnt
private
private-cache
private-bin arch-audit
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
