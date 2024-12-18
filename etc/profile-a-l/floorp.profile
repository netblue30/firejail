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

dbus-user filter
dbus-user.own org.mozilla.floorp.*
ignore apparmor
ignore dbus-user none

# Redirect
include firefox-common.profile
