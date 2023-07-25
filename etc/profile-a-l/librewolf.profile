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

# To enable KeePassXC Plugin add one of the following lines to your librewolf.local.
# Note: Start KeePassXC before Librewolf and keep it open to allow communication between them.
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

whitelist /usr/share/librewolf

# Add the next line to your librewolf.local to enable private-bin (Arch Linux).
#private-bin dbus-launch,dbus-send,librewolf,sh
# Add the next line to your librewolf.local to enable private-etc.
# Note: private-etc must first be enabled in firefox-common.local.
#private-etc librewolf

dbus-user filter
dbus-user.own io.gitlab.librewolf.*
dbus-user.own org.mozilla.librewolf.*
# Add the next line to your librewolf.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Add the next line to your librewolf.local to allow inhibiting screensavers.
#dbus-user.talk org.freedesktop.ScreenSaver
# Add the next lines to your librewolf.local for plasma browser integration.
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
# Add the next line to your librewolf.local to allow screensharing under Wayland.
#dbus-user.talk org.freedesktop.portal.Desktop
# Also add the next line to your librewolf.local if screensharing does not work with
# the above lines (depends on the portal implementation).
#ignore noroot
ignore apparmor
ignore dbus-user none

# Redirect
include firefox-common.profile
