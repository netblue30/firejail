# Firejail profile for kcalc
# Description: Simple and scientific calculator
# This file is overwritten after every install/update
# Persistent local customizations
include kcalc.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/kxmlgui5/kcalc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/kxmlgui5/kcalc
mkfile ${HOME}/.config/kcalcrc
mkfile ${HOME}/.kde/share/config/kcalcrc
mkfile ${HOME}/.kde4/share/config/kcalcrc
allow  ${HOME}/.config/kcalcrc
allow  ${HOME}/.kde/share/config/kcalcrc
allow  ${HOME}/.kde4/share/config/kcalcrc
allow  ${HOME}/.local/share/kxmlgui5/kcalc
allow  /usr/share/config.kcfg/kcalc.kcfg
allow  /usr/share/kcalc
allow  /usr/share/kconf_update/kcalcrc.upd
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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

disable-mnt
private-bin kcalc
private-cache
private-dev
private-etc alternatives,fonts,ld.so.cache,locale,locale.conf
# private-lib - problems on Arch
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute
