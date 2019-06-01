# Firejail profile for hexchat
# Description: IRC client for X based on X-Chat 2
# This file is overwritten after every install/update
# Persistent local customizations
include hexchat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/hexchat
noblacklist /usr/share/perl*

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/hexchat
whitelist ${HOME}/.config/hexchat
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
# debug note: private-bin requires perl, python, etc on some systems
private-bin hexchat,python*
private-dev
#private-lib - python problems
private-tmp

# memory-deny-write-execute - breaks python
