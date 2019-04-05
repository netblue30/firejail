# Firejail profile for frozen-bubble
# Description: Cool game where you pop out the bubbles
# This file is overwritten after every install/update
# Persistent local customizations
include frozen-bubble.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.frozen-bubble

include disable-common.inc
include disable-devel.inc
# requires /usr/bin/perl
#include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.frozen-bubble
whitelist ${HOME}/.frozen-bubble
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

disable-mnt
# private-bin frozen-bubble
private-dev
# private-etc alternatives
private-tmp
