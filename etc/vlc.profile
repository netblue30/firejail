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

private-bin vlc,cvlc,nvlc,rvlc,qvlc,svlc
private-dev
private-tmp
