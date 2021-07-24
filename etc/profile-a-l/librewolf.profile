# Firejail profile for Librewolf
# Description: Firefox fork based on privacy
# This file is overwritten after every install/update
# Persistent local customizations
include librewolf.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/librewolf
nodeny  ${HOME}/.librewolf

mkdir ${HOME}/.cache/librewolf
mkdir ${HOME}/.librewolf
allow  ${HOME}/.cache/librewolf
allow  ${HOME}/.librewolf

# Add the next lines to your librewolf.local if you want to use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# To enable KeePassXC Plugin add one of the following lines to your librewolf.local.
# NOTE: start KeePassXC before Librewolf and keep it open to allow communication between them.
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

allow  /usr/share/doc
allow  /usr/share/gtk-doc/html
allow  /usr/share/mozilla
allow  /usr/share/webext
include whitelist-usr-share-common.inc

# Add the next line to your librewolf.local to enable private-bin (Arch Linux).
#private-bin dbus-launch,dbus-send,librewolf,sh
# Add the next line to your librewolf.local to enable private-etc.
# NOTE: private-etc must first be enabled in firefox-common.local.
#private-etc librewolf

dbus-user filter
# Add the next line to your librewolf.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Add the next line to your librewolf.local to allow inhibiting screensavers.
#dbus-user.talk org.freedesktop.ScreenSaver
# Add the next lines to your librewolf.local for plasma browser integration.
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
# Add the next three lines to your librewolf.local to allow screensharing under Wayland.
#whitelist ${RUNUSER}/pipewire-0
#whitelist /usr/share/pipewire/client.conf
#dbus-user.talk org.freedesktop.portal.*
# Also add the next line to your librewolf.local if screensharing does not work with
# the above lines (depends on the portal implementation).
#ignore noroot
ignore dbus-user none

# Redirect
include firefox-common.profile
