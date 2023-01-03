# Firejail profile for linuxqq
# Description: IM client based on Electron
# This file is overwritten after every install/update
# Persistent local customizations
include linuxqq.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/QQ
noblacklist ${HOME}/.mozilla

mkdir ${HOME}/.config/QQ
whitelist ${HOME}/.config/QQ
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${DESKTOP}

include allow-bin-sh.inc
include disable-shell.inc

# Add the next line to your linuxqq.local if your kernel allows unprivileged userns clone.
#include chromium-common-hardened.inc.profile

ignore apparmor
noprinters

# If you don't need/want to save anything to disk you can add `private` to your linuxqq.local.
#private
private-etc alsa,alternatives,ca-certificates,crypto-policies,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,login.defs,machine-id,nsswitch.conf,os-release,passwd,pki,pulse,resolv.conf,ssl,xdg
private-opt QQ

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.portal.Desktop
dbus-user.talk org.freedesktop.portal.Fcitx
dbus-user.talk org.freedesktop.portal.IBus
dbus-user.talk org.freedesktop.ScreenSaver
dbus-user.talk org.gnome.Mutter.IdleMonitor
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk org.mozilla.*
ignore dbus-user none

read-only ${HOME}/.mozilla/firefox/profiles.ini

# Redirect
include electron.profile
