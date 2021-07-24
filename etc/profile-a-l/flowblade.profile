# Firejail profile for flowblade
# Description: Non-linear video editor
# This file is overwritten after every install/update
# Persistent local customizations
include flowblade.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/flowblade
nodeny  ${HOME}/.flowblade

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
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

