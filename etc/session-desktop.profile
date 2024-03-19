# Firejail profile for session-desktop
# Description: Encrypted messenger
# This file is overwritten after every install/update
# Persistent local customizations
include session-desktop.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

ignore noexec /tmp

noblacklist ${HOME}/.config/Session

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Session
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Session
whitelist /opt/Session
whitelist /opt/session-desktop
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
?HAS_APPIMAGE: ignore noinput
noinput
nonewprivs
noprinters
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot
seccomp.block-secondary
tracelog

disable-mnt
private-bin session-desktop*,session-messenger-desktop*
private-cache
?HAS_APPIMAGE: ignore private-dev
private-dev
private-etc @network,@tls-ca,@x11
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.impl.*
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.portal.*
dbus-user.talk org.freedesktop.secrets
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
?ALLOW_TRAY: dbus-user.own org.kde.*
dbus-system none

# breaks app
#restrict-namespaces
