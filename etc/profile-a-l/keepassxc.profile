# Firejail profile for keepassxc
# Description: Cross Platform Password Manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepassxc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/keepassxc
noblacklist ${HOME}/.keepassxc
# 2.2.4 needs this path when compiled with "Native messaging browser extension"
noblacklist ${HOME}/.mozilla
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/keepassxc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
nodvd
<<<<<<< HEAD
# Breaks 'Lock database when session is locked or lid is closed' (#2899).
# Also breaks (Plasma) tray icon,
# you can safely uncomment it or add to keepassxc.local if you don't need these features.
#
=======
>>>>>>> dbus filter (1)
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none
tracelog

private-bin keepassxc,keepassxc-cli,keepassxc-proxy
private-dev
private-etc alternatives,fonts,ld.so.cache,machine-id
private-tmp

dbus-user filter
dbus-user.own org.keepassxc.KeePassXC
dbus-user.talk org.freedesktop.ScreenSaver
dbus-user.talk com.canonical.AppMenu.Registrar
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.login1.Manager
dbus-user.talk org.gnome.ScreenSaver
dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk org.gnome.SessionManager.Presence
dbus-user.talk org.gnome.SessionManager
dbus-user.talk com.canonical.Unity.Session
dbus-user.talk org.freedesktop.login1.Session
dbus-system none

# Mutex is stored in /tmp by default, which is broken by private-tmp
join-or-start keepassxc
