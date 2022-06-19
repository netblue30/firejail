# Firejail profile for vlc
# Description: Multimedia player and streamer
# This file is overwritten after every install/update
# Persistent local customizations
include vlc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/vlc
noblacklist ${HOME}/.config/vlc
noblacklist ${HOME}/.config/aacs
noblacklist ${HOME}/.local/share/vlc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

read-only ${DESKTOP}
mkdir ${HOME}/.cache/vlc
mkdir ${HOME}/.config/vlc
mkdir ${HOME}/.local/share/vlc
whitelist ${HOME}/.cache/vlc
whitelist ${HOME}/.config/vlc
whitelist ${HOME}/.config/aacs
whitelist ${HOME}/.local/share/vlc
include whitelist-common.inc
include whitelist-player-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp

private-bin cvlc,nvlc,qvlc,rvlc,svlc,vlc
private-dev
private-tmp

dbus-user filter
dbus-user.own org.mpris.MediaPlayer2.vlc
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.ScreenSaver
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk org.mpris.MediaPlayer2.Player
dbus-system none
