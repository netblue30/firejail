# Firejail profile for frozen-bubble
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/frozen-bubble.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.frozen-bubble

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.frozen-bubble
whitelist ~/.frozen-bubble
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

# private-bin frozen-bubble
private-dev
# private-etc none
private-tmp
