# Firejail profile for sniffnet
# Description: Network traffic monitor
# This file is overwritten after every install/update
# Persistent local customizations
include sniffnet.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/sniffnet

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
#caps.drop all
caps.keep net_admin,net_raw
netfilter
nodvd
nogroups
noinput
#nonewprivs # breaks network traffic capture for unprivileged users
#noroot
notv
nou2f
novideo
#seccomp
tracelog

disable-mnt
#private-bin sniffnet
# private-dev prevents (some) interfaces from being shown.
private-etc @network,@tls-ca
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
