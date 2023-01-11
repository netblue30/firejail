# Firejail profile for QMediathekView
# Description: Search, download or stream files from mediathek.de
# This file is overwritten after every install/update
# Persistent local customizations
include QMediathekView.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/QMediathekView
noblacklist ${HOME}/.local/share/QMediathekView

noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.config/smplayer
noblacklist ${HOME}/.config/totem
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.config/xplayer
noblacklist ${HOME}/.local/share/totem
noblacklist ${HOME}/.local/share/xplayer
noblacklist ${HOME}/.mplayer
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist ${HOME}/.config/QMediathekView
whitelist ${HOME}/.local/share/QMediathekView

whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.config/smplayer
whitelist ${HOME}/.config/totem
whitelist ${HOME}/.config/vlc
whitelist ${HOME}/.config/xplayer
whitelist ${HOME}/.local/share/totem
whitelist ${HOME}/.local/share/xplayer
whitelist ${HOME}/.mplayer

whitelist ${DOWNLOADS}
whitelist ${VIDEOS}

whitelist /usr/share/qtchooser
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin mplayer,mpv,QMediathekView,smplayer,totem,vlc,xplayer
private-cache
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,group,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,login.defs,nsswitch.conf,passwd,pki,pulse,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute - breaks on Arch (see issue #1803)
restrict-namespaces
