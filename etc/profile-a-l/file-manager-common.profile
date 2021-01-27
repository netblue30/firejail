# Firejail profile for file managers
# Description: Common profile for GUI file managers
# This file is overwritten after every install/update
# Persistent local customizations
include file-manager-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# File managers need to be able to see everything under ${HOME}
# and be able to start arbitrary applications

ignore noexec ${HOME}

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
#include disable-programs.inc

allusers
#apparmor
caps.drop all
#net none
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-dev

#dbus-user none
#dbus-system none
