# Firejail profile for smuxi-frontend-gnome
# Description: Multi protocol chat client with Twitter support
# This file is overwritten after every install/update
# Persistent local customizations
include smuxi-frontend-gnome.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/smuxi
noblacklist ${HOME}/.config/smuxi
noblacklist ${HOME}/.local/share/smuxi

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/smuxi
mkdir ${HOME}/.config/smuxi
mkdir ${HOME}/.local/share/smuxi
whitelist ${HOME}/.cache/smuxi
whitelist ${HOME}/.config/smuxi
whitelist ${HOME}/.local/share/smuxi
whitelist ${DOWNLOADS}
include whitelist-common.inc
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
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin bash,mono,mono-sgen,sh,smuxi-frontend-gnome
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,hostname,hosts,ld.so.cache,ld.so.conf,machine-id,mono,passwd,pki,pulse,resolv.conf,selinux,ssl,xdg
private-tmp

dbus-user none
dbus-system none
