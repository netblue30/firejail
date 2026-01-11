# Firejail profile for fragments
# Description: Fast, easy and free BitTorrent client (GTK4 GUI for transmission-daemon)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include fragments.local
# Persistent global definitions
include globals.local

include whitelist-runuser-common.inc
whitelist ${RUNUSER}/at-spi
whitelist /usr/share/fragments

private-bin fragments
private-bin transmission-daemon
private-cache

ignore dbus-user none
dbus-user filter
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.portal.Desktop
dbus-user.own de.haeckerfelix.Fragments.*
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.a11y.Bus

ignore memory-deny-write-execute

noblacklist ${HOME}/.cache/fragments
noblacklist ${HOME}/.config/fragments

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/fragments
mkdir ${HOME}/.config/fragments
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/fragments
whitelist ${HOME}/.config/fragments
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
