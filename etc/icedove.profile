# Firejail profile for icedove
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/icedove.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/icedove
noblacklist ~/.gnupg
noblacklist ~/.icedove

mkdir ~/.cache/icedove
mkdir ~/.gnupg
mkdir ~/.icedove
whitelist ~/.cache/icedove
whitelist ~/.gnupg
whitelist ~/.icedove
include /etc/firejail/whitelist-common.inc

ignore private-tmp

include /etc/firejail/firefox.profile

# CLOBBERED COMMENTS
# Users have icedove set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories
# allow browsers
