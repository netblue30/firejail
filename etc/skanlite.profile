# Firejail profile for skanlite
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/skanlite.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
notv
# protocol unix,inet,inet6
seccomp
shell none

# private-bin skanlite
# private-dev
# private-etc
# private-tmp
nodvd
