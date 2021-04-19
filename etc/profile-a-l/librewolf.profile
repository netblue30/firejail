# Firejail profile for Librewolf
# Description: Firefox fork based on privacy
# This file is overwritten after every install/update
# Persistent local customizations
include librewolf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/librewolf
noblacklist ${HOME}/.librewolf

mkdir ${HOME}/.cache/librewolf
mkdir ${HOME}/.librewolf
whitelist ${HOME}/.cache/librewolf
whitelist ${HOME}/.librewolf

# Add the next lines to your librewolf.local if you want to use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# Uncomment or put in your librewolf.local one of the following whitelist to enable KeePassXC Plugin
# NOTE: start KeePassXC before Librewolf and keep it open to allow communication between them
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

whitelist /usr/share/doc
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext
include whitelist-usr-share-common.inc

# Add the next line to your librewolf.local to enable private-bin (Arch Linux).
#private-bin dbus-launch,dbus-send,librewolf,sh
# Add the next line to your librewolf.local to enable private-etc. Note
# that private-etc must first be enabled in firefox-common.local.
#private-etc librewolf

dbus-user filter
# Uncomment or put in your librewolf.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Uncomment or put in your librewolf.local to allow to inhibit screensavers
#dbus-user.talk org.freedesktop.ScreenSaver
# Uncomment or put in your librewolf.local for plasma browser integration
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
# Uncomment or put in your librewolf.local to allow screen sharing under wayland.
#whitelist ${RUNUSER}/pipewire-0
#dbus-user.talk org.freedesktop.portal.*
# Also uncomment or put in your librewolf.local if screen sharing sharing still
# does not work with the above lines (might depend on the portal
# implementation)
#ignore noroot
ignore dbus-user none

# Redirect
include firefox-common.profile
