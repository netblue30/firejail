# ranger file manager profile
noblacklist /usr/bin/perl
#noblacklist /usr/bin/cpan*
noblacklist /usr/share/perl*
noblacklist /usr/lib/perl*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
net none
nonewprivs
noroot
nogroups
protocol unix
seccomp
nosound

private-tmp
private-dev

