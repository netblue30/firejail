# Firejail profile for atom
# Description: A hackable text editor for the 21st Century
# This file is overwritten after every install/update
# Persistent local customizations
include atom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

#include whitelist-runuser-common.inc

caps.drop all
# net none
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-cache
private-dev
private-tmp
