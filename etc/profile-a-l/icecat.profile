# Firejail profile for icecat
# This file is overwritten after every install/update
# Persistent local customizations
include icecat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.config/mozilla
noblacklist ${HOME}/.mozilla

mkdir ${HOME}/.cache/mozilla/icecat
mkdir ${HOME}/.config/mozilla
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/icecat
whitelist ${HOME}/.config/mozilla
whitelist ${HOME}/.mozilla
whitelist /usr/share/icecat

private-etc icecat

# Redirect
include firefox-common.profile
