# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/vlc.local

# VLC media player profile
noblacklist ${HOME}/.config/vlc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
#ipc-namespace
netfilter
# nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin vlc,cvlc,nvlc,rvlc,qvlc,svlc,vlc-wrapper
private-dev
private-tmp

# memory-deny-write-execute - breaks playing videos
noexec ${HOME}
noexec /tmp
