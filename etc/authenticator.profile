# Firejail profile for authenticator
# Description: 2FA code generator for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include authenticator.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Authenticator
noblacklist ${HOME}/.config/Authenticator

# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

# apparmor
caps.drop all
netfilter
no3d
# nodbus - makes settings immutable
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
# novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
# private-bin authenticator,python*
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,pki,resolv.conf,ssl
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
