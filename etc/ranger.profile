# Firejail profile for ranger
# Description: File manager with an ncurses frontend written in Python
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ranger.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/ranger

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

# Allow perl
# noblacklist ${PATH}/cpan*
noblacklist ${PATH}/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nodbus
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
