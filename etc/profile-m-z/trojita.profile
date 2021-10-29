# Firejail profile for trojita
# Description: Qt mail client
# This file is overwritten after every install/update
# Persistent local customizations
include trojita.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.abook
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.cache/flaska.net/trojita
noblacklist ${HOME}/.config/flaska.net

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.abook
mkdir ${HOME}/.cache/flaska.net/trojita
mkdir ${HOME}/.config/flaska.net
whitelist ${HOME}/.abook
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${HOME}/.cache/flaska.net/trojita
whitelist ${HOME}/.config/flaska.net
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
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

# disable-mnt
# Add "ignore private-bin" for hyperlinks or have a look at the private-bins in firefox.profile and firefox-common.profile.
private-bin trojita
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,hostname,hosts,ld.so.cache,ld.so.preload,pki,resolv.conf,selinux,ssl,xdg
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.secrets
dbus-system none

read-only ${HOME}/.mozilla/firefox/profiles.ini
