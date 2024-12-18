# Firejail profile for torbrowser
# Description: This profile was tested with www-client/torbrowser::torbrowser
# on Gentoo Linux.
# This file is overwritten after every install/update
# Persistent local customizations
include torbrowser.local
# Persistent global definitions
include globals.local

ignore dbus-user none

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla

blacklist /sys/class/net
blacklist /usr/libexec

mkdir ${HOME}/.cache/mozilla/torbrowser
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/torbrowser
whitelist ${HOME}/.mozilla
include whitelist-usr-share-common.inc

dbus-user filter
dbus-user.own org.mozilla.torbrowser.*

include firefox-common.profile
