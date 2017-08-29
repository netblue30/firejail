# Firejail profile for itch
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/itch.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/itch

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

whitelist ~/.config/itch

include /etc/firejail/whitelist-common.inc

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

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
