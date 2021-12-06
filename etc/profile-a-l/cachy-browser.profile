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

# Add the next lines to your cachy-browser.local if you want to use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# To enable KeePassXC Plugin add one of the following lines to your cachy-browser.local.
# NOTE: start KeePassXC before CachyBrowser and keep it open to allow communication between them.
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

whitelist /usr/share/doc
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext
include whitelist-usr-share-common.inc

# Add the next line to your cachy-browser.local to enable private-bin (Arch Linux).
#private-bin dbus-launch,dbus-send,cachy-browser,sh
# Add the next line to your cachy-browser.local to enable private-etc.
# NOTE: private-etc must first be enabled in firefox-common.local.
#private-etc cachy-browser

dbus-user filter
# Add the next line to your cachy-browser.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Add the next line to your cachy-browser.local to allow inhibiting screensavers.
#dbus-user.talk org.freedesktop.ScreenSaver
# Add the next lines to your cachy-browser.local for plasma browser integration.
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
# Add the next three lines to your cachy-browser.local to allow screensharing under Wayland.
#whitelist ${RUNUSER}/pipewire-0
#whitelist /usr/share/pipewire/client.conf
#dbus-user.talk org.freedesktop.portal.*
# Also add the next line to your cachy-browser.local if screensharing does not work with
# the above lines (depends on the portal implementation).
#ignore noroot
ignore dbus-user none

# Redirect
include firefox-common.profile
