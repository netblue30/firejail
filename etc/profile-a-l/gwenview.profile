# Firejail profile for gwenview
# Description: Image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gwenview.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/GIMP
nodeny  ${HOME}/.config/gwenviewrc
nodeny  ${HOME}/.config/org.kde.gwenviewrc
nodeny  ${HOME}/.gimp*
nodeny  ${HOME}/.kde/share/apps/gwenview
nodeny  ${HOME}/.kde/share/config/gwenviewrc
nodeny  ${HOME}/.kde4/share/apps/gwenview
nodeny  ${HOME}/.kde4/share/config/gwenviewrc
nodeny  ${HOME}/.local/share/gwenview
nodeny  ${HOME}/.local/share/kxmlgui5/gwenview
nodeny  ${HOME}/.local/share/org.kde.gwenview

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-var-common.inc

apparmor
caps.drop all
# net none
netfilter
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
shell none
# tracelog

private-bin gimp*,gwenview,kbuildsycoca4,kdeinit4
private-dev
private-etc alternatives,fonts,gimp,gtk-2.0,kde4rc,kde5rc,ld.so.cache,machine-id,passwd,pulse,xdg

# dbus-user none
# dbus-system none

# memory-deny-write-execute
