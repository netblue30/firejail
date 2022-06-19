# Firejail profile for mate-color-select
# This file is overwritten after every install/update
# Persistent local customizations
include mate-color-select.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-common.inc

apparmor
caps.drop all
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
protocol unix
seccomp

disable-mnt
private-bin mate-color-select
private-etc alternatives,fonts,ld.so.cache,ld.so.preload
private-dev
private-lib
private-tmp

memory-deny-write-execute
