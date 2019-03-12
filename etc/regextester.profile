# Firejail profile for regextester
# Description: A simple regex tester built for Pantheon Shell
# This file is overwritten after every install/update
# Persistent local customizations
include regextester.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
# nodbus - makes settings immutable
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
tracelog

disable-mnt
private-bin regextester
private-cache
private-dev
private-etc alternatives,fonts
private-lib libgranite.so.*
private-tmp

memory-deny-write-execute

# never write anything
read-only ${HOME}
