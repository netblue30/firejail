# Firejail profile for coyim
# Description: GTK Jabber client written in Go
# This file is overwritten after every install/update
# Persistent local customizations
include coyim.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/coyim

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.config/coyim
whitelist ${HOME}/.config/coyim

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ssl
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
