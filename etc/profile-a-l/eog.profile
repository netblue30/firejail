# Firejail profile for eog
# Description: Eye of GNOME graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eog.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/eog

allow  /usr/share/eog

# private-bin, private-etc and private-lib break 'Open With' / 'Open in file manager'.
# Add the next lines to your eog.local if you need that functionality.
#ignore private-bin
#ignore private-etc
#ignore private-lib

private-bin eog

# broken on Debian 10 (buster) running LXDE got the folowing error:
# Failed to register: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: org.freedesktop.DBus.Error.ServiceUnknown
#dbus-user filter
#dbus-user.own org.gnome.eog
#dbus-user.talk ca.desrt.dconf
dbus-system none

# Redirect
include eo-common.profile
