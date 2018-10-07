# Firejail profile for hexchat
# Description: IRC client for X based on X-Chat 2
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/hexchat.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/hexchat
noblacklist /usr/share/perl*

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/hexchat
whitelist ${HOME}/.config/hexchat
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

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
noexec ${HOME}
noexec /tmp
