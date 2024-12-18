# Firejail profile for neochat
# Description: Matrix Client
# This file is overwritten after every install/update
# Persistent local customizations
include neochat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/KDE/neochat
noblacklist ${HOME}/.config/KDE
noblacklist ${HOME}/.config/KDE/neochat
noblacklist ${HOME}/.config/neochatrc
noblacklist ${HOME}/.config/neochat.notifyrc
noblacklist ${HOME}/.local/share/KDE/neochat

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/KDE/neochat
mkdir ${HOME}/.local/share/KDE/neochat
whitelist ${HOME}/.cache/KDE/neochat
whitelist ${HOME}/.local/share/KDE/neochat
whitelist ${DOWNLOADS}
include whitelist-1793-workaround.inc
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin neochat
private-dev
private-etc @tls-ca,@x11,dbus-1,host.conf,mime.types,rpc,services
private-tmp

dbus-user filter
dbus-user.own org.kde.neochat
dbus-user.talk org.freedesktop.Notifications
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk org.kde.kwalletd5
dbus-system none

restrict-namespaces
