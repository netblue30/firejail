# Firejail profile for unknown-horizons
# Description: 2D realtime strategy simulation
# This file is overwritten after every install/update
# Persistent local customizations
include unknown-horizons.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.unknown-horizons

include disable-common.inc
include disable-exec.inc
include disable-programs.inc

mkdir ${HOME}/.unknown-horizons
whitelist ${HOME}/.unknown-horizons
include whitelist-common.inc
include whitelist-runuser-common.inc
whitelist /usr/share/unknown-horizons
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
#private-bin unknown-horizons
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,pki,ssl
private-tmp

# doesn't work - maybe all Tcl/Tk programs have this problem
#memory-deny-write-execute
restrict-namespaces
