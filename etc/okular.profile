# Firejail profile for okular
# Description: Universal document viewer
# This file is overwritten after every install/update
# Persistent local customizations
include okular.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/okular
noblacklist ${HOME}/.config/okularpartrc
noblacklist ${HOME}/.config/okularrc
noblacklist ${HOME}/.kde/share/apps/okular
noblacklist ${HOME}/.kde/share/config/okularpartrc
noblacklist ${HOME}/.kde/share/config/okularrc
noblacklist ${HOME}/.kde4/share/apps/okular
noblacklist ${HOME}/.kde4/share/config/okularpartrc
noblacklist ${HOME}/.kde4/share/config/okularrc
noblacklist ${HOME}/.local/share/okular
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/poppler
whitelist /usr/share/okular
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
tracelog

private-bin kbuildsycoca4,kdeinit4,lpr,okular
private-dev
private-etc Trolltech.conf,X11,alternatives,bumblebee,dbus-1,drirc,fonts,glvnd,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
# private-tmp - on KDE we need access to the real /tmp for data exchange with email clients

# memory-deny-write-execute

join-or-start okular
