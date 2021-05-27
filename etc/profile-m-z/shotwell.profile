# Firejail profile for shotwell
# Description: A digital photo organizer designed for the GNOME desktop environment
# This file is overwritten after every install/update
# Persistent local customizations
include shotwell.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/shotwell
noblacklist ${HOME}/.local/share/shotwell

noblacklist ${PICTURES}
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/shotwell
mkdir ${HOME}/.local/share/shotwell
whitelist ${HOME}/.cache/shotwell
whitelist ${HOME}/.local/share/shotwell
whitelist ${PICTURES}
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
protocol unix
seccomp
shell none
tracelog

private-bin shotwell
private-cache
private-dev
private-etc alternatives,fonts,machine-id
private-opt none
private-tmp

dbus-user filter
dbus-user.own org.gnome.Shotwell
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gtk.vfs.UDisks2VolumeMonitor
dbus-system none
