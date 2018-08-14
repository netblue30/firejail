# Firejail profile for arch-audit
# Description: A utility like pkg-audit based on Arch CVE Monitoring Team data
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/arch-audit.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist /var/lib/pacman

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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
