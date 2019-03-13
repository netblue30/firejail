# Firejail profile for flowblade
# Description: Non-linear video editor
# This file is overwritten after every install/update
# Persistent local customizations
include flowblade.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/flowblade
noblacklist ${HOME}/.flowblade

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
