# Firejail profile for geary
# Description: Lightweight email client designed for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include geary.local
# Persistent global definitions
# added by included profile
#include globals.local

# Users have Geary set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

ignore dbus-user filter
ignore dbus-system none
ignore private-tmp

noblacklist ${HOME}/.cache/geary
noblacklist ${HOME}/.config/geary
noblacklist ${HOME}/.local/share/geary

mkdir ${HOME}/.cache/geary
mkdir ${HOME}/.config/geary
mkdir ${HOME}/.local/share/geary
whitelist ${HOME}/.cache/geary
whitelist ${HOME}/.config/geary
whitelist ${HOME}/.local/share/geary
whitelist /usr/share/geary

read-only ${HOME}/.config/mimeapps.list

# allow Mozilla browsers
# Redirect
include firefox.profile
