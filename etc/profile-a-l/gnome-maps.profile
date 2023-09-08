# Firejail profile for gnome-maps
# Description: Map application for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-maps.local
# Persistent global definitions
include globals.local

# Some distributions use gapplications to start gnome-maps over D-Bus. As firecfg cannot handle that, you need to run the following command.
# sed -e "s/Exec=gapplication launch org.gnome.Maps %U/Exec=gnome-maps %U/" -e "s/DBusActivatable=true/DBusActivatable=false/" "/usr/share/applications/org.gnome.Maps.desktop" > "~/.local/share/applications/org.gnome.Maps.desktop"

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.cache/champlain
noblacklist ${HOME}/.cache/org.gnome.Maps
noblacklist ${HOME}/.local/share/maps-places.json

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/champlain
mkfile ${HOME}/.local/share/maps-places.json
whitelist ${HOME}/.cache/champlain
whitelist ${HOME}/.local/share/maps-places.json
whitelist ${DOWNLOADS}
whitelist ${PICTURES}
whitelist /usr/share/gnome-maps
whitelist /usr/share/libgweather
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
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin gjs,gnome-maps
#private-cache # gnome-maps cache all maps/satelite-images
private-dev
private-etc @tls-ca,@x11,clutter-1.0,gconf,host.conf,mime.types,pkcs11,rpc,services
private-tmp

dbus-user filter
dbus-user.own org.gnome.Maps
#dbus-user.talk org.freedesktop.secrets
#dbus-user.talk org.gnome.OnlineAccounts
dbus-system filter
#dbus-system.talk org.freedesktop.NetworkManager
dbus-system.talk org.freedesktop.GeoClue2

restrict-namespaces
