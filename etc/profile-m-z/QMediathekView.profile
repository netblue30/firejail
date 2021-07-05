# Firejail profile for QMediathekView
# Description: Search, download or stream files from mediathek.de
# This file is overwritten after every install/update
# Persistent local customizations
include QMediathekView.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/QMediathekView
nodeny  ${HOME}/.local/share/QMediathekView

nodeny  ${HOME}/.config/mpv
nodeny  ${HOME}/.config/smplayer
nodeny  ${HOME}/.config/totem
nodeny  ${HOME}/.config/vlc
nodeny  ${HOME}/.config/xplayer
nodeny  ${HOME}/.local/share/totem
nodeny  ${HOME}/.local/share/xplayer
nodeny  ${HOME}/.mplayer
nodeny  ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

allow  /usr/share/qtchooser
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin mplayer,mpv,QMediathekView,smplayer,totem,vlc,xplayer
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute - breaks on Arch (see issue #1803)
