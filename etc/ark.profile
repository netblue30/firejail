# Firejail profile for ark
# Description: Archive utility
# This file is overwritten after every install/update
# Persistent local customizations
include ark.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/arkrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/ark
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
# net none
netfilter
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

private-bin 7z,ark,bash,lrzip,lsar,lz4,lzop,p7zip,rar,sh,tclsh,unar,unrar,unzip,zip,zipinfo
#private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,drirc,fonts,glvnd,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,samba,smb.conf,xdg

private-dev
private-tmp

