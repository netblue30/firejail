# Firejail profile for bijiben
# Description: Simple Note Viewer
# This file is overwritten after every install/update
# Persistent local customizations
include bijiben.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/bijiben

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/bijiben
whitelist ${HOME}/.local/share/bijiben
whitelist ${HOME}/.cache/tracker
whitelist /usr/share/bijiben
whitelist /usr/share/tracker
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin bijiben
# private-cache -- access to .cache/tracker is required
private-dev
private-etc dconf,fonts,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload
private-tmp

dbus-user filter
dbus-user.own org.gnome.Notes
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Tracker1
dbus-system none

env WEBKIT_FORCE_SANDBOX=0
