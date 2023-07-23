# Firejail profile for abrowser
# This file is overwritten after every install/update
# Persistent local customizations
include abrowser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla

mkdir ${HOME}/.cache/mozilla/abrowser
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/abrowser
whitelist ${HOME}/.mozilla
whitelist /usr/share/abrowser

# private-etc must first be enabled in firefox-common.profile
#private-etc abrowser

# Redirect
include firefox-common.profile
