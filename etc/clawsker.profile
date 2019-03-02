# Firejail profile for clawsker
# Description: An applet to edit Claws Mail's hidden preferences
# This file is overwritten after every install/update
# Persistent local customizations
include clawsker.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.claws-mail

# Allow perl (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/cpan*
noblacklist ${PATH}/core_perl
noblacklist ${PATH}/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${HOME}/.claws-mail
include whitelist-common.inc

caps.drop all
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

# disable-mnt
# private
private-bin clawsker,perl
private-cache
private-dev
private-etc alternatives,fonts
private-lib girepository-1.*,libgirepository-1.*,perl*
private-tmp

# memory-deny-write-execute - breaks on Arch
noexec ${HOME}
noexec /tmp
