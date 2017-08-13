# Firejail profile for etr
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/etr.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.etr

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.etr
whitelist ~/.etr
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

# private-bin etr
private-dev
# private-etc none
private-tmp
