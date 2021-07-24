# Firejail profile for neverball
# Description: 3D floor-tilting game
# This file is overwritten after every install/update
# Persistent local customizations
include neverball.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.neverball

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.neverball
allow  ${HOME}/.neverball
allow  /usr/share/neverball
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
shell none
tracelog

disable-mnt
private-bin neverball
private-cache
private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,machine-id
private-tmp

dbus-user none
dbus-system none
