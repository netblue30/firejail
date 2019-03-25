# Firejail profile for kid3
# Description: Audio Tag Editor
# This file is overwritten after every install/update
# Persistent local customizations
include kid3.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${HOME}/.config/kid3rc

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
netfilter
nodbus
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

private-cache
private-dev
private-etc alternatives,drirc,fonts,kde5rc,gtk-3.0,dconf,machine-id,ca-certificates,ssl,pki,hostname,hosts,resolv.conf,pulse,,crypto-policies
private-tmp
private-opt none
private-srv none

memory-deny-write-execute
