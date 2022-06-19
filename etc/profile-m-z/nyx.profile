# Firejail profile for nyx
# Description: Command-line status monitor for tor
# This file is overwritten after every install/update
# Persistent local customizations
include nyx.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

noblacklist ${HOME}/.nyx

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.nyx
whitelist ${HOME}/.nyx
include whitelist-common.inc
include whitelist-var-common.inc

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
protocol unix,inet,inet6
seccomp

disable-mnt
private-bin nyx,python*
private-cache
private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.preload,passwd,tor
private-opt none
private-srv none
private-tmp

dbus-user none
dbus-system none
