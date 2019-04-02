# Firejail profile for autokey
# Description: Desktop automation utility
# This file is overwritten after every install/update
# Persistent local customizations
include autokey-common.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/autokey
noblacklist ${HOME}/.local/share/autokey

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*
noblacklist /usr/share/python2*
noblacklist /usr/share/python3*

include disable-common.inc
include disable-devel.inc
# disable-exec.inc might break scripting functionality
#include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-cache
private-dev
private-tmp

# memory-deny-write-execute - Breaks on Arch
