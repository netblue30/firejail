# Firejail profile for gwenview
# Description: Image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gwenview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.config/gwenviewrc
noblacklist ${HOME}/.config/org.kde.gwenviewrc
noblacklist ${HOME}/.gimp*
noblacklist ${HOME}/.kde/share/apps/gwenview
noblacklist ${HOME}/.kde/share/config/gwenviewrc
noblacklist ${HOME}/.kde4/share/apps/gwenview
noblacklist ${HOME}/.kde4/share/config/gwenviewrc
noblacklist ${HOME}/.local/share/gwenview
noblacklist ${HOME}/.local/share/org.kde.gwenview

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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
notv
nou2f
novideo
protocol unix
seccomp
shell none
# tracelog

private-bin gimp*,gwenview,kbuildsycoca4,kdeinit4
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dbus-1,drirc,fonts,gimp,glvnd,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg

# memory-deny-write-execute
