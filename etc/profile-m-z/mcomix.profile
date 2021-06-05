# Firejail profile for mcomix
# Description: A comic book and manga viewer 
# This file is overwritten after every install/update
# Persistent local customizations
include mcomix.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mcomix
noblacklist ${HOME}/.local/share/mcomix
noblacklist ${DOCUMENTS}

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow python (blacklisted by disable-interpreters.inc)
#1.2
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/mcomix
mkdir ${HOME}/.local/share/mcomix
whitelist /usr/share/mcomix
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

#1.2 python2
private-bin 7z,lha,mcomix,mutool,python*,rar,sh,unrar,unzip
private-cache
private-dev
#1.2 gtk-2.0
private-etc alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,X11,xdg
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${HOME}/.config/mcomix
read-write ${HOME}/.local/share/mcomix
#to allow ${HOME}/.local/share/recently-used.xbel
read-write ${HOME}/.local/share
#1.2 tip, make a symbolic link to .cache/thumbnails
read-write ${HOME}/.thumbnails
