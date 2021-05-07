# Firejail profile for gnome-logs
# Description: Viewer for the systemd journal
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-logs.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /var/log/journal
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
no3d
nodvd
noinput
nonewprivs
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin gnome-logs
private-cache
private-dev
private-etc alternatives,fonts,localtime,machine-id
private-lib gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*
private-tmp
writable-var-log

dbus-user filter
dbus-user.own org.gnome.Logs
dbus-user.talk ca.desrt.dconf
dbus-system none

# Add 'ignore read-only ${HOME}' to your gnome-logs.local if you export logs to a file under your ${HOME}.
read-only ${HOME}
