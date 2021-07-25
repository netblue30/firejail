# Firejail profile for fossamail
# This file is overwritten after every install/update
# Persistent local customizations
include fossamail.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/fossamail
noblacklist ${HOME}/.fossamail
noblacklist ${HOME}/.gnupg

mkdir ${HOME}/.cache/fossamail
mkdir ${HOME}/.fossamail
mkdir ${HOME}/.gnupg
whitelist ${HOME}/.cache/fossamail
whitelist ${HOME}/.fossamail
whitelist ${HOME}/.gnupg
include whitelist-common.inc

# allow browsers
# Redirect
include firefox.profile
