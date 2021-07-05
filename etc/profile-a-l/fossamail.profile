# Firejail profile for fossamail
# This file is overwritten after every install/update
# Persistent local customizations
include fossamail.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.cache/fossamail
nodeny  ${HOME}/.fossamail
nodeny  ${HOME}/.gnupg

mkdir ${HOME}/.cache/fossamail
mkdir ${HOME}/.fossamail
mkdir ${HOME}/.gnupg
allow  ${HOME}/.cache/fossamail
allow  ${HOME}/.fossamail
allow  ${HOME}/.gnupg
include whitelist-common.inc

# allow browsers
# Redirect
include firefox.profile
