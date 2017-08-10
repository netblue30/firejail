# Firejail profile for geary
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/geary.local
# Persistent global definitions
include /etc/firejail/globals.local

# Users have Geary set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ~/.gnupg
noblacklist ~/.local/share/geary

mkdir ~/.gnupg
mkdir ~/.local/share/geary
whitelist ~/.gnupg
whitelist ~/.local/share/applications
whitelist ~/.local/share/geary
include /etc/firejail/whitelist-common.inc

ignore private-tmp

read-only ~/.config/mimeapps.list

# allow browsers
# Redirect
include /etc/firejail/firefox.profile
