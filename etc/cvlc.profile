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
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

# clvc doesn't like private-bin
#private-bin vlc,cvlc,nvlc,rvlc,qvlc,svlc
private-dev
private-tmp
