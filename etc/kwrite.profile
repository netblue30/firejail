# Firejail profile for kwrite
# Description: Simple text editor
# This file is overwritten after every install/update
# Persistent local customizations
include kwrite.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/katepartrc
noblacklist ${HOME}/.config/katerc
noblacklist ${HOME}/.config/kateschemarc
noblacklist ${HOME}/.config/katesyntaxhighlightingrc
noblacklist ${HOME}/.config/katevirc
noblacklist ${HOME}/.config/kwriterc
noblacklist ${HOME}/.local/share/kwrite
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

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
# nosound - KWrite is using ALSA!
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin kbuildsycoca4,kdeinit4,kwrite
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dbus-1,drirc,fonts,glvnd,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg
private-tmp


join-or-start kwrite
