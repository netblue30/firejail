# Firejail profile for rhythmbox
# Description: Music player and organizer for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include rhythmbox.local
# Persistent global definitions
include globals.local

nodeny  ${MUSIC}
nodeny  ${HOME}/.cache/rhythmbox
nodeny  ${HOME}/.local/share/rhythmbox

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

allow  /usr/share/rhythmbox
allow  /usr/share/lua
allow  /usr/share/libquvi-scripts
allow  /usr/share/tracker
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin rhythmbox,rhythmbox-client
private-cache
private-dev
private-tmp

dbus-user filter
dbus-user.own org.gnome.Rhythmbox3
dbus-user.own org.mpris.MediaPlayer2.rhythmbox
dbus-user.own org.gnome.UPnP.MediaServer2.Rhythmbox
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gtk.vfs.*
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.gnome.SettingsDaemon.MediaKeys
dbus-system filter
dbus-system.talk org.freedesktop.Avahi
