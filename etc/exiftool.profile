# exiftool profile
noblacklist /usr/bin/perl
noblacklist /usr/share/perl*
noblacklist /usr/lib/perl*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
netfilter
net none
no3d
shell none
tracelog

blacklist /tmp/.X11-unix

# private-bin exiftool,perl
private-tmp
private-dev
private-etc none


