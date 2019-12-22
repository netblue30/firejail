# Firejail profile for lugaru
# Description: Ninja rabbit fighting game
# This file is overwritten after every install/update
# Persistent local customizations
include lugaru.local
# Persistent global definitions
include globals.local

# note: crashes after entering

noblacklist ${HOME}/.config/lugaru
noblacklist ${HOME}/.local/share/lugaru

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/lugaru
mkdir ${HOME}/.local/share/lugaru
whitelist ${HOME}/.config/lugaru
whitelist ${HOME}/.local/share/lugaru
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin lugaru
private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp
