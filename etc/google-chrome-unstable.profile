# Firejail profile for google-chrome-unstable
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-chrome-unstable.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/google-chrome-unstable
noblacklist ${HOME}/.config/google-chrome-unstable

mkdir ${HOME}/.cache/google-chrome-unstable
mkdir ${HOME}/.config/google-chrome-unstable
whitelist ${HOME}/.cache/google-chrome-unstable
whitelist ${HOME}/.config/google-chrome-unstable

# Redirect
include /etc/firejail/chromium-common.profile
