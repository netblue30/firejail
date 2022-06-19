# Firejail profile for Seafile
# Description: Seafile desktop client.
# This file is overwritten after every install/update
# Persistent local customizations
include seafile-applet.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Seafile
noblacklist ${HOME}/Seafile/.seafile-data

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.ccnet
mkdir ${HOME}/.config/Seafile
mkdir ${HOME}/Seafile
whitelist ${HOME}/.ccnet
whitelist ${HOME}/.config/Seafile
whitelist ${HOME}/Seafile

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin seaf-cli,seaf-daemon,seafile-applet
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl
#private-opt none
private-tmp

dbus-user none
dbus-system none
