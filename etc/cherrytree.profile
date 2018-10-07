# Firejail profile for cherrytree
# Description: Hierarchical note taking application
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cherrytree.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/cherrytree
noblacklist ${DOCUMENTS}

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
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
