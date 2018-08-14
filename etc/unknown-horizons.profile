# Firejail profile for unknown-horizons
# Description: 2D realtime strategy simulation
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/unknown-horizons.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.unknown-horizons

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.unknown-horizons
whitelist ${HOME}/.unknown-horizons
include /etc/firejail/whitelist-common.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,netlink,inet,inet6
seccomp
shell none

# private-bin unknown-horizons
private-dev
# private-etc ca-certificates,ssl,pki,crypto-policies
private-tmp
