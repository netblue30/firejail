# Firejail profile for linuxqq
# Description: IM client based on Electron
# This file is overwritten after every install/update
# Persistent local customizations
include linuxqq.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/QQ

# sh is needed to allow Firefox to open links
include allow-bin-sh.inc

include disable-shell.inc

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.config/QQ
whitelist ${HOME}/.config/QQ
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
# Allow D-Bus communication with Firefox for opening links
dbus-user.talk org.mozilla.*
ignore dbus-user none

# Redirect
include electron-common.profile
