# Firejail profile for AnyDesk
# This file is overwritten after every install/update
# Persistent local customizations
include anydesk.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.anydesk

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.anydesk
allow  ${HOME}/.anydesk
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin anydesk
private-dev
private-tmp
