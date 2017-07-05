# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/ranger.local

# ranger file manager profile
noblacklist /usr/bin/perl
#noblacklist /usr/bin/cpan*
noblacklist /usr/share/perl*
noblacklist /usr/lib/perl*
noblacklist ~/.config/ranger

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nonewprivs
noroot
protocol unix
seccomp
nosound

private-dev
