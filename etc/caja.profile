# Firejail profile for caja
# Description: File manager for the MATE desktop
# This file is overwritten after every install/update
# Persistent local customizations
include caja.local
# Persistent global definitions
include globals.local

# Caja is started by systemd on most systems. Therefore it is not firejailed by default. Since there
# is already a caja process running on MATE desktops firejail will have no effect.

noblacklist ${HOME}/.local/share/Trash
# noblacklist ${HOME}/.config/caja - disable-programs.inc is disabled, see below
# noblacklist ${HOME}/.local/share/caja-python

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# include disable-programs.inc

allusers
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none
tracelog

# caja needs to be able to start arbitrary applications so we cannot blacklist their files
# private-bin caja
# private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,prelink.conf.d,pulse,xdg
# private-tmp
