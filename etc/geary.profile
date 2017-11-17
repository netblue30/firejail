# Firejail profile for geary
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/geary.local
# Persistent global definitions
include /etc/firejail/globals.local

# Users have Geary set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.local/share/geary

mkdir ${HOME}/.gnupg
mkdir ${HOME}/.local/share/geary
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.local/share/geary
include /etc/firejail/whitelist-common.inc

ignore private-tmp

read-only ${HOME}/.config/mimeapps.list

# allow browsers
# Redirect
include /etc/firejail/firefox.profile
