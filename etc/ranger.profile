# Firejail profile for ranger
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ranger.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

# noblacklist /usr/bin/cpan*
noblacklist /usr/bin/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*
noblacklist ${HOME}/.config/ranger

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp

private-dev
