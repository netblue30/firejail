# Firejail profile for iagno
# Description: Reversi clone for Gnome desktop
# This file is overwritten after every install/update
# Persistent local customizations
include iagno.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

whitelist ${HOME}/.local/share/glib-2.0/schemas
whitelist /usr/share/gdm
whitelist /usr/share/iagno
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary

disable-mnt
private-bin iagno
private-dev
private-etc @x11,gconf
private-tmp

#dbus-user none
#dbus-system none

restrict-namespaces
