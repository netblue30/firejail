# Firejail profile for kate
# Description: Powerful text editor
# This file is overwritten after every install/update
# Persistent local customizations
include kate.local
# Persistent global definitions
include globals.local

#private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,drirc,fonts,glvnd,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
ignore noexec ${HOME}

noblacklist ${HOME}/.config/katemetainfos
noblacklist ${HOME}/.config/katepartrc
noblacklist ${HOME}/.config/katerc
noblacklist ${HOME}/.config/kateschemarc
noblacklist ${HOME}/.config/katesyntaxhighlightingrc
noblacklist ${HOME}/.config/katevirc
noblacklist ${HOME}/.local/share/kate

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
# include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# apparmor
caps.drop all
# net none
# nodbus
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
tracelog

# private-bin kate,kbuildsycoca4,kdeinit4
private-dev
private-tmp

join-or-start kate
