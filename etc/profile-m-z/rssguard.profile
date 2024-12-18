# Firejail profile for rssguard
# Description: Simple (yet powerful) Qt feed reader
# This file is overwritten after every install/update
# Persistent local customizations
include rssguard.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/RSS Guard 4

# Allow nodejs (blacklisted by disable-interpreters.inc)
include allow-nodejs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/RSS Guard 4
whitelist ${HOME}/.config/RSS Guard 4
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
#no3d
nodvd
nogroups
noinput
nonewprivs
noroot
#nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin node,rssguard
private-dev
private-etc @network,@sound,@tls-ca,@x11,mime.types
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
