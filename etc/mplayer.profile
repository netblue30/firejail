# Firejail profile for mplayer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mplayer.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.mplayer

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
# nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin mplayer
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
