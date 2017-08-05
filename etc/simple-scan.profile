# Firejail profile for simple-scan
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/simple-scan.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/simple-scan

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
protocol unix,inet,inet6
shell none
# seccomp
tracelog

# private-bin simple-scan
# private-dev
# private-etc fonts
# private-tmp
