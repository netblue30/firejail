# Firejail profile for floorp
# Description: A customisable Firefox fork with excellent privacy protection
# This file is overwritten after every install/update
# Persistent local customizations
include floorp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/floorp
noblacklist ${HOME}/.floorp

mkdir ${HOME}/.cache/floorp
mkdir ${HOME}/.floorp
whitelist ${HOME}/.cache/floorp
whitelist ${HOME}/.floorp

# Add the next lines to your floorp.local if you want to use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# To enable KeePassXC Plugin add one of the following lines to your floorp.local.
# Note: Start KeePassXC before floorp and keep it open to allow communication between them.
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

dbus-user filter
dbus-user.own org.mozilla.floorp.*
# Add the next line to your floorp.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Add the next line to your floorp.local to allow inhibiting screensavers.
#dbus-user.talk org.freedesktop.ScreenSaver
# Add the next lines to your floorp.local for plasma browser integration.
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
# Add the next line to your floorp.local to allow screensharing under Wayland.
#dbus-user.talk org.freedesktop.portal.Desktop
# Also add the next line to your floorp.local if screensharing does not work with
# the above lines (depends on the portal implementation).
#ignore noroot
ignore apparmor
ignore dbus-user none

# Redirect
include firefox-common.profile
