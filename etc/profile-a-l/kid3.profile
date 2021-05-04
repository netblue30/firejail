# Firejail profile for kid3
# Description: Audio Tag Editor
# This file is overwritten after every install/update
# Persistent local customizations
include kid3.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${HOME}/.config/kid3rc
noblacklist ${HOME}/.local/share/kxmlgui5/kid3

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
shell none
tracelog

private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,drirc,fonts,gtk-3.0,hostname,hosts,kde5rc,machine-id,pki,pulse,resolv.conf,ssl
private-tmp
private-opt none
private-srv none

dbus-user none
dbus-system none

memory-deny-write-execute
