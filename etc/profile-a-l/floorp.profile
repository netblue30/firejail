# Firejail profile for floorp
# Description: A customizable Firefox fork with excellent privacy protection
# This file is overwritten after every install/update
# Persistent local customizations
include floorp.local
# Persistent global definitions
include globals.local

# Profile Sync Daemon support
whitelist ${RUNUSER}/*floorp*
whitelist ${RUNUSER}/psd/*floorp*

noblacklist ${HOME}/.cache/floorp
noblacklist ${HOME}/.floorp

mkdir ${HOME}/.cache/floorp
mkdir ${HOME}/.floorp
whitelist ${HOME}/.cache/floorp
whitelist ${HOME}/.floorp

# Fix PWAs in the Application Launcher (ignore entry from disable-common.inc)
ignore read-only ${HOME}/.local/share/applications

dbus-user filter
dbus-user.own org.mozilla.floorp.*
ignore apparmor
ignore dbus-user none

# Redirect
include firefox-common.profile
