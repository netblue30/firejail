# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include sol.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# all necessary files in $HOME are in whitelist-common.inc
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
# no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin sol
private-cache
private-dev
private-tmp

# memory-deny-write-execute
