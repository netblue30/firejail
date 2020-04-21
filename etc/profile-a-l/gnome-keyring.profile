# Firejail profile for gnome-keyring
# Description: Stores passwords and encryption keys
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gnome-keyring.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gnupg

whitelist ${HOME}/.gnupg
whitelist ${DOWNLOADS}
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
include whitelist-common.inc
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
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
#private-bin gnome-keyrin*,secret-tool
private-cache
private-dev
#private-lib alternatives,gnome-keyring,libsecret-1.so.*,pkcs11,security
private-tmp

# dbus-user none
# dbus-system none

memory-deny-write-execute
