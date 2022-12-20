# Firejail profile for goldendict
# This file is overwritten after every install/update
# Persistent local customizations
include goldendict.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.goldendict
noblacklist ${HOME}/.cache/GoldenDict

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.goldendict
mkdir ${HOME}/.cache/GoldenDict
whitelist ${HOME}/.goldendict
whitelist ${HOME}/.cache/GoldenDict
whitelist /usr/share/goldendict
# The default path of dictionaries
whitelist /usr/share/stardict/dic
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# no3d leads to the libGL MESA-LOADER errors
#no3d
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
seccomp.block-secondary
tracelog

disable-mnt
private-bin goldendict
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
