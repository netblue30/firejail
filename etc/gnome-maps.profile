# Firejail profile for gnome-maps
# Description: Map application for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-maps.local
# Persistent global definitions
include globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.cache/champlain
noblacklist ${HOME}/.cache/org.gnome.Maps
noblacklist ${HOME}/.local/share/flatpak
noblacklist ${HOME}/.local/share/maps-places.json

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/champlain
mkfile ${HOME}/.local/share/maps-places.json
whitelist ${HOME}/.cache/champlain
whitelist ${HOME}/.local/share/maps-places.json
whitelist ${DOWNLOADS}
whitelist ${PICTURES}
whitelist /usr/share/gnome-maps
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin gjs,gnome-maps
# private-cache -- gnome-maps cache all maps/satelite-images
private-dev
private-etc alternatives,ca-certificates,clutter-1.0,crypto-policies,dconf,drirc,fonts,gconf,gcrypt,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,pkcs11,pki,protocols,resolv.conf,rpc,services,ssl,X11,xdg
private-tmp

