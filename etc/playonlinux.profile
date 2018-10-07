# Firejail profile for playonlinux
# Description: Front-end for Wine
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/playonlinux.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/steam
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.PlayOnLinux

# nc is needed to run playonlinux
noblacklist ${PATH}/nc

# Allow access to perl
noblacklist ${PATH}/cpan*
noblacklist ${PATH}/core_perl
noblacklist ${PATH}/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*

include /etc/firejail/disable-common.inc
# playonlinux uses perl
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
seccomp
