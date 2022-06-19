# Firejail profile for flatseal
# This file is overwritten after every install/update
# Persistent local customizations
include com.github.tchx84.Flatseal.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/flatpak/overrides
noblacklist /var/lib/flatpak/app

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/flatpak/overrides
whitelist ${HOME}/.local/share/flatpak/overrides
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
noprinters
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
private-bin com.github.tchx84.Flatseal,gjs
private-cache
private-dev
private-etc alternatives,dconf,fonts,gtk-3.0,ld.so.cache,ld.so.preload
private-tmp

dbus-user filter
dbus-user.own com.github.tchx84.Flatseal
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.impl.portal.PermissionStore
dbus-user.talk org.gnome.Software
dbus-system none

read-write ${HOME}/.local/share/flatpak/overrides
