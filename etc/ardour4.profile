# Firejail profile for ardour4
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ardour4.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/ardour4

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.config/ardour4
whitelist ~/.config/ardour4
whitelist ~/Music
whitelist ~/Música
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix
seccomp
shell none
tracelog

# private-bin ardour4
private-dev
# private-etc ardour4
private-tmp
