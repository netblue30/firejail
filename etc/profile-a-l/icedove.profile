# Firejail profile for icedove
# This file is overwritten after every install/update
# Persistent local customizations
include icedove.local
# Persistent global definitions
# added by included profile
#include globals.local

# Users have icedove set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

nodeny  ${HOME}/.cache/icedove
nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.icedove

mkdir ${HOME}/.cache/icedove
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.icedove
allow  ${HOME}/.cache/icedove
allow  ${HOME}/.gnupg
allow  ${HOME}/.icedove
include whitelist-common.inc

ignore private-tmp

# allow browsers
# Redirect
include firefox.profile
