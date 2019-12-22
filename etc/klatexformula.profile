# Firejail profile for klatexformula
# Description: generating images from LaTeX equations
# This file is overwritten after every install/update
# Persistent local customizations
include klatexformula.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.kde/share/apps/klatexformula
noblacklist ${HOME}/.klatexformula

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
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

private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,drirc,fonts,glvnd,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,xdg
private-tmp
