# Firejail profile for gnome-passwordsafe
# Description: Password manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-passwordsafe.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/cracklib
whitelist /usr/share/passwordsafe
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
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
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin gnome-passwordsafe,python3*
private-cache
private-dev
private-etc dconf,fonts,gtk-3.0,passwd
private-tmp

dbus-user filter
dbus-user.own org.gnome.PasswordSafe
dbus-user.talk ca.desrt.dconf
dbus-system none
