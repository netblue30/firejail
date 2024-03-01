# Firejail profile for green-recorder
# Description: A simple screen recorder for Linux desktop (supports Wayland & Xorg)
# This file is overwritten after every install/update
# Persistent local customizations
include green-recorder.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

noblacklist ${HOME}/.config/green-recorder

# Allow python 3 (blacklisted by disable-interpreters.inc)
include allow-python3.inc

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/green-recorder
whitelist ${HOME}/.config/green-recorder
whitelist ${DOWNLOADS}
whitelist ${VIDEOS}
whitelist /usr/share/ffmpeg
whitelist /usr/share/green-recorder
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix
# allow set_mempolicy, which is required to encode using libx265
seccomp !set_mempolicy
seccomp.block-secondary
tracelog

disable-mnt
private-bin awk,bash,convert,ffmpeg,green-recorder,grep,mv,pactl,ps,python*,sh,sleep,xdg-open,xdpyinfo,xwininfo
private-cache
private-dev
private-etc @x11
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.gnome.Shell.*
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-system none

restrict-namespaces
