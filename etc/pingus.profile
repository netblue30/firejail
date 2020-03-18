# Firejail profile for pingus
# Description: Free Lemmings(TM) clone
# This file is overwritten after every install/update
# Persistent local customizations
include pingus.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.pingus

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.pingus
whitelist ${HOME}/.pingus
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none

# private-bin pingus
private-dev
private-tmp
