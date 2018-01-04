# Firejail profile for Popcorn-Time
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Popcorn-Time.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Popcorn-Time
noblacklist ${HOME}/.cache/Popcorn-Time

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
