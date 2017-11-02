# Firejail profile for vlc
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/vlc.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.local/share/vlc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
# nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin vlc,cvlc,nvlc,rvlc,qvlc,svlc
private-dev
private-tmp

# mdwe is disabled due to breaking hardware accelerated decoding
# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
