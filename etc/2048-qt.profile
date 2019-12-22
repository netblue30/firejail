# Firejail profile for 2048-qt
# Description: Mathematics based puzzle game
# This file is overwritten after every install/update
# Persistent local customizations
include 2048-qt.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/2048-qt
noblacklist ${HOME}/.config/xiaoyong

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/2048-qt
mkdir ${HOME}/.config/xiaoyong
whitelist ${HOME}/.config/2048-qt
whitelist ${HOME}/.config/xiaoyong
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
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
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,drirc,fonts,glvnd,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp
