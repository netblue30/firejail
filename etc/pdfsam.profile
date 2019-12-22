# Firejail profile for pdfsam
# Description: PDF Split and Merge
# This file is overwritten after every install/update
# Persistent local customizations
include pdfsam.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
machine-id
net none
no3d
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

private-bin archlinux-java,awk,bash,dirname,expr,find,grep,java,java-config,ls,pdfsam,readlink,sh,sort,uname,which
private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,dconf,fonts,gconf,gtk-2.0,gtk-3.0,java.conf,java-10-openjdk,java-9-openjdk,java-8-openjdk,java-7-openjdk,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp

