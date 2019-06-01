# Firejail profile for bleachbit
# Description: Delete unnecessary files from the system
# This file is overwritten after every install/update
# Persistent local customizations
include bleachbit.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# include disable-programs.inc

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

private-dev
# private-tmp

# memory-deny-write-execute breaks some systems, see issue #1850
# memory-deny-write-execute
