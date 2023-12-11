# Firejail profile for fractal
# Description: Desktop client for Matrix
# This file is overwritten after every install/update
# Persistent local customizations
include fractal.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/fractal

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/fractal
whitelist ${HOME}/.cache/fractal
whitelist ${DOWNLOADS}
whitelist /usr/share/fractal
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin fractal
private-cache
private-dev
private-etc @tls-ca,@x11,host.conf,mime.types
private-tmp

dbus-user filter
dbus-user.own org.gnome.Fractal
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-system none

restrict-namespaces
