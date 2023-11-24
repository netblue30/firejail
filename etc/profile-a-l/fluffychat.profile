# Firejail profile for fluffychat
# Description: Easy to use matrix messenger
# This file is overwritten after every install/update
# Persistent local customizations
include fluffychat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/fluffychat

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.local/share/fluffychat
whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/share/fluffychat
whitelist /opt/fluffychat
whitelist /usr/share/fluffychat
include whitelist-common.inc
include whitelist-run-common.inc
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
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin firefox,fluffychat,sh,which,zenity
private-cache
private-dev
private-etc X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.secrets
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*
dbus-system filter
dbus-system.talk org.freedesktop.NetworkManager

restrict-namespaces
