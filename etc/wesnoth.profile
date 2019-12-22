# Firejail profile for wesnoth
# Description: Fantasy turn-based strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include wesnoth.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/wesnoth
noblacklist ${HOME}/.config/wesnoth
noblacklist ${HOME}/.local/share/wesnoth

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/wesnoth
mkdir ${HOME}/.config/wesnoth
mkdir ${HOME}/.local/share/wesnoth
whitelist ${HOME}/.cache/wesnoth
whitelist ${HOME}/.config/wesnoth
whitelist ${HOME}/.local/share/wesnoth
include whitelist-common.inc

caps.drop all
nodvd
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp
