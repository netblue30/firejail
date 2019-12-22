# Firejail profile for manaplus
# Description: 2D MMORPG client for Evol Online and The Mana World
# This file is overwritten after every install/update
# Persistent local customizations
include manaplus.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mana
noblacklist ${HOME}/.local/share/mana

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/mana
mkdir ${HOME}/.config/mana/mana
mkdir ${HOME}/.local/share/mana
whitelist ${HOME}/.config/mana
whitelist ${HOME}/.local/share/mana
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodbus
nodvd
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

disable-mnt
private-bin manaplus
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp
