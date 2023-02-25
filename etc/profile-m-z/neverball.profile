# Firejail profile for neverball
# Description: 3D floor-tilting game
# This file is overwritten after every install/update
# Persistent local customizations
include neverball.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.neverball

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.neverball
whitelist ${HOME}/.neverball
whitelist /usr/share/neverball
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
tracelog

disable-mnt
private-bin neverball
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
