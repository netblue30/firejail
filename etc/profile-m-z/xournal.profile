# Firejail profile for xournal
# Description: Note taking and PDF editing
# This file is overwritten after every install/update
# Persistent local customizations
include xournal.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/xournal
whitelist /usr/share/poppler
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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

private-bin xournal
private-cache
private-dev
private-etc alternatives,fonts,group,ld.so.cache,ld.so.preload,machine-id,passwd
# TODO should use private-lib
private-tmp

dbus-user none
dbus-system none
