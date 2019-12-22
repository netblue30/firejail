# Firejail profile for rhythmbox
# Description: Music player and organizer for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include rhythmbox.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${HOME}/.cache/rhythmbox
noblacklist ${HOME}/.local/share/rhythmbox

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/rhythmbox
whitelist /usr/share/lua
whitelist /usr/share/libquvi-scripts
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
netfilter
# nodbus - makes settings immutable
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin rhythmbox,rhythmbox-client
private-dev
#private-etc X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp
