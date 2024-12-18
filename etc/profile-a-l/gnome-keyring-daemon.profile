# Firejail profile for gnome-keyring-daemon
# Description: Stores passwords and encryption keys
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gnome-keyring-daemon.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
#include disable-x11.inc # x11 none
include disable-x11.inc
include disable-xdg.inc

whitelist ${RUNUSER}/gnupg
whitelist ${RUNUSER}/keyring
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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
seccomp.block-secondary
tracelog
x11 none

disable-mnt
#private-bin gnome-keyrin*,secret-tool
private-cache
private-dev
#private-lib alternatives,gnome-keyring,libsecret-1.so.*,pkcs11,security
private-tmp

#dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
