# Firejail profile for amarok
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/amarok.local
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
protocol unix,inet,inet6
shell none

# private-bin amarok
private-dev
# private-etc none
private-tmp

# CLOBBERED COMMENTS
# seccomp
