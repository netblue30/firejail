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
ignore dbus-user none

# Redirect
include firefox-common.profile
