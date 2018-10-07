# Firejail profile for simutrans
# Description: Transportation simulator
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/simutrans.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.simutrans

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.simutrans
whitelist ${HOME}/.simutrans
include /etc/firejail/whitelist-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix
seccomp
shell none

# private-bin simutrans
private-dev
# private-etc none
private-tmp
