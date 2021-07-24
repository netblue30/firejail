# Firejail profile for com.github.dahenson.agenda
# Description: Simple, fast, no-nonsense to-do (task) list
# This file is overwritten after every install/update
# Persistent local customizations
include com.github.dahenson.agenda.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/agenda
nodeny  ${HOME}/.config/agenda
nodeny  ${HOME}/.local/share/agenda

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/agenda
mkdir ${HOME}/.config/agenda
mkdir ${HOME}/.local/share/agenda
allow  ${HOME}/.cache/agenda
allow  ${HOME}/.config/agenda
allow  ${HOME}/.local/share/agenda
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
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
shell none
tracelog

disable-mnt
private-bin com.github.dahenson.agenda
private-cache
private-dev
private-etc dconf,fonts,gtk-3.0
private-tmp

dbus-user filter
dbus-user.own com.github.dahenson.agenda
dbus-user.talk ca.desrt.dconf
dbus-system none

read-only ${HOME}
read-write ${HOME}/.cache/agenda
read-write ${HOME}/.config/agenda
read-write ${HOME}/.local/share/agenda
