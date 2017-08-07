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
nogroups
nonewprivs
noroot
protocol unix,netlink
seccomp
shell none

# private-bin frozen-bubble
private-dev
# private-etc none
private-tmp

# CLOBBERED COMMENTS
# depending on your usage, you can enable some of the commands below:
# nosound
