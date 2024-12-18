# Firejail profile for kcalc
# Description: Simple and scientific calculator
# This file is overwritten after every install/update
# Persistent local customizations
include kcalc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/kxmlgui5/kcalc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# Legacy paths
#mkdir ${HOME}/.kde/share/config
#mkdir ${HOME}/.kde4/share/config
#mkfile ${HOME}/.kde/share/config/kcalcrc
#mkfile ${HOME}/.kde4/share/config/kcalcrc

mkdir ${HOME}/.local/share/kxmlgui5/kcalc
mkfile ${HOME}/.config/kcalcrc
whitelist ${HOME}/.config/kcalcrc
whitelist ${HOME}/.kde/share/config/kcalcrc
whitelist ${HOME}/.kde4/share/config/kcalcrc
whitelist ${HOME}/.local/share/kxmlgui5/kcalc
whitelist /usr/share/config.kcfg/kcalc.kcfg
whitelist /usr/share/kcalc
whitelist /usr/share/kconf_update/kcalcrc.upd
include whitelist-common.inc
include whitelist-run-common.inc
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
tracelog

disable-mnt
private-bin kcalc
private-cache
private-dev
private-etc
#private-lib # problems on Arch
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute
restrict-namespaces
