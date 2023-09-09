# Firejail profile for gnome-logs
# Description: Viewer for the systemd journal
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-logs.local
# Persistent global definitions
include globals.local

whitelist /usr/share/gnome-logs

private-bin gnome-logs
private-lib gdk-pixbuf-2.*,gio,gvfs/libgvfscommon.so,libgconf-2.so.*,librsvg-2.so.*

dbus-user filter
dbus-user.own org.gnome.Logs
dbus-user.talk ca.desrt.dconf
ignore dbus-user none

# Redirect
include system-log-common.profile
