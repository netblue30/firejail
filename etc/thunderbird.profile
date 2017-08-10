# Firejail profile for thunderbird
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/thunderbird.local
# Persistent global definitions
include /etc/firejail/globals.local

# Users have thunderbird set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ~/.cache/thunderbird
noblacklist ~/.gnupg
noblacklist ~/.icedove
noblacklist ~/.thunderbird

mkdir ~/.cache/thunderbird
mkdir ~/.gnupg
mkdir ~/.icedove
mkdir ~/.thunderbird
whitelist ~/.cache/thunderbird
whitelist ~/.gnupg
whitelist ~/.icedove
whitelist ~/.local/share/applications
whitelist ~/.thunderbird
include /etc/firejail/whitelist-common.inc

ignore private-tmp

read-only ~/.config/mimeapps.list

# allow browsers
# Redirect
include /etc/firejail/firefox.profile
