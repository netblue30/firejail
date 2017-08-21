# Firejail profile for handbrake
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/handbrake.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/ghb

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
