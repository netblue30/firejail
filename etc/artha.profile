# Firejail profile for artha
# Description: A free cross-platform English thesaurus based on WordNet
# This file is overwritten after every install/update
# Persistent local customizations
include artha.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/artha.conf
noblacklist ${HOME}/.config/enchant

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/artha.conf
mkdir ${HOME}/.config/enchant
whitelist ${HOME}/.config/artha.conf
whitelist ${HOME}/.config/enchant
whitelist /usr/share/artha
whitelist /usr/share/wordnet
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
# net none - breaks on Ubuntu
no3d
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin artha,enchant,notify-send
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-lib libnotify.so.*
private-tmp

memory-deny-write-execute
