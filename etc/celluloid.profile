# Firejail profile for celluloid
# Description: Simple GTK+ frontend for mpv
# This file is overwritten after every install/update
# Persistent local customizations
include celluloid.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/celluloid
noblacklist ${HOME}/.config/gnome-mpv
noblacklist ${HOME}/.config/youtube-dl
noblacklist ${MUSIC}
noblacklist ${VIDEOS}

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

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodbus
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin celluloid,env,gnome-mpv,python*,youtube-dl
private-cache
private-etc X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-dev
private-tmp

