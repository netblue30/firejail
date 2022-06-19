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

disable-mnt
private
private-bin iagno
private-dev
private-tmp

# dbus-user none
# dbus-system none
