# Firejail profile for midori
# Description: Lightweight web browser
# This file is overwritten after every install/update
# Persistent local customizations
include midori.local
# Persistent global definitions
include globals.local

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

noblacklist ${HOME}/.config/midori
noblacklist ${HOME}/.local/share/midori
# noblacklist ${HOME}/.local/share/webkit
# noblacklist ${HOME}/.local/share/webkitgtk
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/midori
mkdir ${HOME}/.config/midori
mkdir ${HOME}/.local/share/midori
mkdir ${HOME}/.local/share/webkit
mkdir ${HOME}/.local/share/webkitgtk
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/gnome-mplayer/plugin
whitelist ${HOME}/.cache/midori
whitelist ${HOME}/.config/gnome-mplayer
whitelist ${HOME}/.config/midori
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.local/share/midori
whitelist ${HOME}/.local/share/webkit
whitelist ${HOME}/.local/share/webkitgtk
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
# noroot - problems on Ubuntu 14.04
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
