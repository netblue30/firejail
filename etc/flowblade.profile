# Firejail profile for flowblade
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/flowblade.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/flowblade
noblacklist ${HOME}/.flowblade

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

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
