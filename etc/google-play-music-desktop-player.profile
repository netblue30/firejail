# Firejail profile for google-play-music-desktop-player
# This file is overwritten after every install/update
# Persistent local customizations
include google-play-music-desktop-player.local
# Persistent global definitions
include globals.local

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
# noexec /tmp breaks mpris support
ignore noexec /tmp

noblacklist ${HOME}/.config/Google Play Music Desktop Player

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Google Play Music Desktop Player
# whitelist ${HOME}/.config/pulse
# whitelist ${HOME}/.pulse
whitelist ${HOME}/.config/Google Play Music Desktop Player
include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-tmp
