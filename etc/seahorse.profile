# Firejail profile for seahorse
# Description: GNOME application for managing PGP keys
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.ssh
noblacklist /tmp/ssh-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# whitelisting in ${HOME} breaks file encryption feature of nautilus.
# once #2882 is fixed this can be uncommented and nowhitelisted in seahorse-tool.profile
#mkdir ${HOME}/.gnupg
#mkdir ${HOME}/.ssh
#whitelist ${HOME}/.gnupg
#whitelist ${HOME}/.ssh
whitelist /tmp/ssh-*
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /usr/share/seahorse
whitelist /usr/share/seahorse-nautilus
#include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dbus-1,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
writable-run-user
