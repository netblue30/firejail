# Firejail profile for geary
# Description: Lightweight email client designed for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include geary.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/evolution
noblacklist ${HOME}/.cache/folks
noblacklist ${HOME}/.cache/geary
noblacklist ${HOME}/.config/evolution
noblacklist ${HOME}/.config/geary
noblacklist ${HOME}/.local/share/evolution
noblacklist ${HOME}/.local/share/geary
noblacklist ${HOME}/.local/share/pki
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.pki

include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/evolution
mkdir ${HOME}/.cache/folks
mkdir ${HOME}/.cache/geary
mkdir ${HOME}/.config/evolution
mkdir ${HOME}/.config/geary
mkdir ${HOME}/.local/share/evolution
mkdir ${HOME}/.local/share/geary
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/evolution
whitelist ${HOME}/.cache/folks
whitelist ${HOME}/.cache/geary
whitelist ${HOME}/.config/evolution
whitelist ${HOME}/.config/geary
whitelist ${HOME}/.local/share/evolution
whitelist ${HOME}/.local/share/geary
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.mozilla/firefox/profiles.ini
whitelist ${HOME}/.pki
whitelist /usr/share/geary
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#ipc-namespace # may cause issues with X11
#machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
#nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

#disable-mnt
#private-bin geary,sh
private-cache
private-dev
private-etc @tls-ca,@x11,mailcap,mime.types
private-tmp

dbus-user filter
dbus-user.own org.gnome.Geary
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.Contacts
dbus-user.talk org.gnome.OnlineAccounts
dbus-user.talk org.gnome.evolution.dataserver.AddressBook10
dbus-user.talk org.gnome.evolution.dataserver.Sources5
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk org.mozilla.*
dbus-system none

restrict-namespaces
