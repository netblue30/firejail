# Firejail profile for kwin_x11
# This file is overwritten after every install/update
# Persistent local customizations
include kwin_x11.local
# Persistent global definitions
include globals.local

# fix automatical kwin_x11 sandboxing:
# echo KDEWM=kwin_x11 >> ~/.pam_environment

noblacklist ${HOME}/.cache/kwin
noblacklist ${HOME}/.config/kwinrc
noblacklist ${HOME}/.config/kwinrulesrc
noblacklist ${HOME}/.local/share/kwin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

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
tracelog

disable-mnt
private-bin kwin_x11
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,drirc,fonts,glvnd,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
private-tmp
