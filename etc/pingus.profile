# Firejail profile for pingus
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pingus.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.pingus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.pingus
whitelist ~/.pingus
include /etc/firejail/whitelist-common.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,netlink
seccomp
shell none

# private-bin pingus
private-dev
# private-etc none
private-tmp
