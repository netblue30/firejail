# Firejail profile for seahorse
# Description: GNOME application for managing PGP keys
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gnupg

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

# whitelisting in ${HOME} breaks file encryption feature of nautilus.
# Once #2882 is fixed this can be activated here and nowhitelisted in seahorse-tool.profile.
#mkdir ${HOME}/.gnupg
#mkdir ${HOME}/.ssh
#whitelist ${HOME}/.gnupg
#whitelist ${HOME}/.ssh
whitelist /tmp/ssh-*
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /usr/share/seahorse
whitelist /usr/share/seahorse-nautilus
whitelist ${RUNUSER}/gnupg
whitelist ${RUNUSER}/keyring
#include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-cache
private-dev
private-etc @tls-ca,@x11,gconf,host.conf,pkcs11,rpc,services,ssh
private-tmp
writable-run-user

dbus-user filter
dbus-user.own org.gnome.seahorse
dbus-user.own org.gnome.seahorse.Application
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.secrets
dbus-system none

restrict-namespaces
