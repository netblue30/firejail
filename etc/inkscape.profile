# Firejail profile for inkscape
# Description: Vector-based drawing program
# This file is overwritten after every install/update
# Persistent local customizations
include inkscape.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/inkscape
noblacklist ${HOME}/.config/inkscape
noblacklist ${HOME}/.inkscape
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}
# Allow exporting .xcf files
noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.gimp*


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

whitelist /usr/share/inkscape
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
nodbus
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
tracelog

# private-bin inkscape,potrace,python* - problems on Debian stretch
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,dconf,drirc,fonts,gconf,gimp,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp

# memory-deny-write-execute
