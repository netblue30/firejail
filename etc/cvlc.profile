# Firejail profile for cvlc
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cvlc.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/vlc

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
tracelog

# clvc doesn't like private-bin
# private-bin vlc,cvlc,nvlc,rvlc,qvlc,svlc
private-dev
private-tmp

# mdwe is disabled due to breaking hardware accelerated decoding
# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
