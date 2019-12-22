# Firejail profile for imagej
# Description: Image processing program with a focus on microscopy images
# This file is overwritten after every install/update
# Persistent local customizations
include imagej.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.imagej

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
ipc-namespace
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

private-bin awk,basename,bash,cut,free,grep,hostname,imagej,ln,ls,mkdir,rm,sort,tail,touch,tr,uname,update-java-alternatives,whoami,xprop
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,java.conf,java-10-openjdk,java-9-openjdk,java-8-openjdk,java-7-openjdk,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp

