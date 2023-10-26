# Firejail profile for telegram
# This file is overwritten after every install/update
# Persistent local customizations
include telegram.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.TelegramDesktop
noblacklist ${HOME}/.local/share/TelegramDesktop
noblacklist ${HOME}/.local/share/telegram-desktop

# Allow opening hyperlinks
include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.TelegramDesktop
mkdir ${HOME}/.local/share/TelegramDesktop
mkdir ${HOME}/.local/share/telegram-desktop
whitelist ${HOME}/.TelegramDesktop
whitelist ${HOME}/.local/share/TelegramDesktop
whitelist ${HOME}/.local/share/telegram-desktop
whitelist ${DOWNLOADS}
whitelist /usr/share/TelegramDesktop
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
noinput
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary

disable-mnt
private-bin Telegram,bash,sh,telegram,telegram-desktop,xdg-open
private-cache
private-dev
private-etc @tls-ca,@x11,os-release
private-tmp

dbus-user filter
dbus-user.own org.telegram.desktop.*
dbus-user.talk org.freedesktop.Notifications
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk org.gnome.Mutter.IdleMonitor
dbus-user.talk org.freedesktop.ScreenSaver
dbus-system none

restrict-namespaces
