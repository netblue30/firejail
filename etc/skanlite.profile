# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/skanlite.local

# skanlite profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
shell none
seccomp
# protocol unix,inet,inet6

# private-bin skanlite
# private-dev
# private-tmp
# private-etc

