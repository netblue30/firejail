# Firejail profile for sqlitebrowser
# Description: GUI editor for SQLite databases
# This file is overwritten after every install/update
# Persistent local customizations
include sqlitebrowser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/sqlitebrowser
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
shell none

private-bin sqlitebrowser
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,group,machine-id,passwd,pki,ssl
private-tmp

# breaks proxy creation
# dbus-user none
# dbus-system none

#memory-deny-write-execute - breaks on Arch (see issue #1803)
