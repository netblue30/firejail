# Firejail profile for atool
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/atool.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

# Allow perl (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/cpan*
noblacklist ${PATH}/core_perl
noblacklist ${PATH}/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin atool
private-dev
private-etc passwd,group
private-tmp
