# Firejail profile for dino
# Description: Modern XMPP Chat Client using GTK/Vala
# This file is overwritten after every install/update
# Persistent local customizations
include dino.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/dino

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.local/share/dino
whitelist ${HOME}/.local/share/dino
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin dino
private-dev
# breaks server connection
#private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl
private-tmp

dbus-user filter
# Integration with notification and other desktop environment functionalities
dbus-user.own im.dino.Dino
# dconf integration
dbus-user.talk ca.desrt.dconf
# Notification support
dbus-user.talk org.freedesktop.Notifications
dbus-system filter
# Integration with systemd-logind or elogind
dbus-system.talk org.freedesktop.login1

restrict-namespaces
