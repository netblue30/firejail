# Firejail profile for Cachy-Browser
# Description: Librewolf fork based on enhanced privacy with gentoo patchset
# This file is overwritten after every install/update
# Persistent local customizations
include cachy-browser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/cachy
noblacklist ${HOME}/.cachy

mkdir ${HOME}/.cache/cachy
mkdir ${HOME}/.cachy
whitelist ${HOME}/.cache/cachy
whitelist ${HOME}/.cachy
whitelist /usr/share/cachy-browser

# Add the next line to your cachy-browser.local to enable private-bin (Arch Linux).
#private-bin dbus-launch,dbus-send,cachy-browser,sh
private-etc cachy-browser

dbus-user filter
dbus-user.own org.mozilla.cachybrowser.*
# Add the next line to your cachy-browser.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Add the next line to your cachy-browser.local to allow inhibiting screensavers.
#dbus-user.talk org.freedesktop.ScreenSaver
# Add the next lines to your cachy-browser.local for plasma browser integration.
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
# Add the next line to your cachy-browser.local to allow screensharing under Wayland.
#dbus-user.talk org.freedesktop.portal.Desktop
# Also add the next line to your cachy-browser.local if screensharing does not work with
# the above lines (depends on the portal implementation).
#ignore noroot
ignore dbus-user none

# Redirect
include firefox-common.profile
