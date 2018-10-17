# Firejail profile for geary
# Description: Lightweight email client designed for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include geary.local
# Persistent global definitions
include globals.local

# Users have Geary set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.local/share/geary

mkdir ${HOME}/.gnupg
mkdir ${HOME}/.config/geary
mkdir ${HOME}/.local/share/geary

whitelist ${HOME}/.gnupg
whitelist ${HOME}/.config/geary
whitelist ${HOME}/.local/share/geary

include whitelist-common.inc

ignore nodbus
ignore private-tmp

read-only ${HOME}/.config/mimeapps.list

# allow browsers
# Redirect
include firefox.profile
