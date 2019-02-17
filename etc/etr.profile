# Firejail profile for etr
# This file is overwritten after every install/update
# Persistent local customizations
include etr.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.etr

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.etr
whitelist ${HOME}/.etr
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,netlink
seccomp
shell none

# private-bin etr
private-dev
# private-etc alternatives
private-tmp
