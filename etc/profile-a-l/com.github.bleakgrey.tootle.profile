# Firejail profile for com.github.bleakgrey.tootle
# Description: Gtk Mastodon client
# This file is overwritten after every install/update
# Persistent local customizations
include com.github.bleakgrey.tootle.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/com.github.bleakgrey.tootle

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/com.github.bleakgrey.tootle
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/com.github.bleakgrey.tootle
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin com.github.bleakgrey.tootle
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.preload,machine-id mime.types,nsswitch.conf,pki,pulse,resolv.conf,ssl,X11,xdg
private-tmp

# Settings are immutable
# dbus-user filter
# dbus-user.own com.github.bleakgrey.tootle
# dbus-user.talk ca.desrt.dconf
dbus-system none
