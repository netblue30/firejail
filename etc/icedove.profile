# Firejail profile for icedove
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/icedove.local
# Persistent global definitions
include /etc/firejail/globals.local

# Users have icedove set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ${HOME}/.cache/icedove
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.icedove

mkdir ${HOME}/.cache/icedove
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.icedove
whitelist ${HOME}/.cache/icedove
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.icedove
include /etc/firejail/whitelist-common.inc

ignore private-tmp

# allow browsers
# Redirect
include /etc/firejail/firefox.profile
