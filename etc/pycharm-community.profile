# Firejail profile for pycharm-community
# This file is overwritten after every install/update
# Persistent local customizations
include pycharm-community.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.PyCharmCE*

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
machine-id
nodvd
nogroups
nosound
notv
nou2f
novideo
shell none
tracelog

#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
# program!
private-cache
private-dev
private-tmp

noexec /tmp
