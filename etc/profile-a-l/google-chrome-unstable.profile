# Firejail profile for google-chrome-unstable
# This file is overwritten after every install/update
# Persistent local customizations
include google-chrome-unstable.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/google-chrome-unstable
noblacklist ${HOME}/.config/google-chrome-unstable

mkdir ${HOME}/.cache/google-chrome-unstable
mkdir ${HOME}/.config/google-chrome-unstable
whitelist ${HOME}/.cache/google-chrome-unstable
whitelist ${HOME}/.config/google-chrome-unstable

# Redirect
include chromium-common.profile
