# Firejail profile for linuxqq
# Description: IM client based on Electron
# This file is overwritten after every install/update
# Persistent local customizations
include linuxqq.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/QQ
noblacklist ${HOME}/.mozilla

include allow-bin-sh.inc

include disable-shell.inc

mkdir ${HOME}/.config/QQ
whitelist ${HOME}/.config/QQ
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${DESKTOP}
whitelist /opt/QQ

ignore apparmor
noprinters

# If you don't need/want to save anything to disk you can add `private` to your linuxqq.local.
#private
private-etc @tls-ca,@x11,host.conf,os-release

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

# Redirect
include electron-common.profile
