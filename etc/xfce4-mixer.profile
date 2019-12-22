# Firejail profile for xfce4-mixer
# Description: Volume control for Xfce
# This file is overwritten after every install/update
# Persistent local customizations
include xfce4-mixer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-mixer.xml

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkfile ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-mixer.xml
whitelist ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-mixer.xml
whitelist /usr/share/xfce4
whitelist /usr/share/xfce4-mixer
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
# nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin xfce4-mixer,xfconf-query
private-cache
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp

memory-deny-write-execute
