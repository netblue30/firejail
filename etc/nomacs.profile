# Firejail profile for nomacs
# Description: a fast and small image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include nomacs.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nomacs
noblacklist ${HOME}/.local/share/nomacs
noblacklist ${HOME}/.local/share/data/nomacs
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
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
tracelog

#private-bin nomacs
private-cache
private-dev
private-etc alternatives,hosts,ca-certificates,ssl,pki,crypto-policies,resolv.conf,drirc,fonts,gtk-3.0,dconf,machine-id,login.defs
private-tmp

memory-deny-write-execute
