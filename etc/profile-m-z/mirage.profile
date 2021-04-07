# Firejail profile for mirage
# Description: Desktop client for Matrix
# This file is overwritten after every install/update
# Persistent local customizations
include mirage.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mirage
noblacklist ${HOME}/.config/mirage
noblacklist ${HOME}/.local/share/mirage

include allow-bin-sh.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/mirage
mkdir ${HOME}/.config/mirage
mkdir ${HOME}/.local/share/mirage
whitelist ${HOME}/.cache/mirage
whitelist ${HOME}/.config/mirage
whitelist ${HOME}/.local/share/mirage
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
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin dirname,env,ldconfig,mirage,readlink,sh,uname
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,drirc,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,mime.types,nsswitch.conf,os-release,pki,pulse,resolv.conf,ssl,X11,xdg
private-tmp

dbus-user none
# Add 'ignore dbus-user none' and below lines to 'mirage.local' for native notifications
# dbus-user filter
# dbus-user.talk org.freedesktop.Notifications
dbus-system none
