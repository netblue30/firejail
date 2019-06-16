# Firejail profile for simutrans
# Description: Transportation simulator
# This file is overwritten after every install/update
# Persistent local customizations
include simutrans.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.simutrans

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.simutrans
whitelist ${HOME}/.simutrans
include whitelist-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix
seccomp
shell none

# private-bin simutrans
private-dev
private-tmp
