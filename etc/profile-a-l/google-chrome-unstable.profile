# Firejail profile for google-chrome-unstable
# This file is overwritten after every install/update
# Persistent local customizations
include google-chrome-unstable.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/google-chrome-unstable
noblacklist ${HOME}/.config/google-chrome-unstable

noblacklist ${HOME}/.config/chrome-unstable-flags.conf
noblacklist ${HOME}/.config/chrome-unstable-flags.config

mkdir ${HOME}/.cache/google-chrome-unstable
mkdir ${HOME}/.config/google-chrome-unstable
whitelist ${HOME}/.cache/google-chrome-unstable
whitelist ${HOME}/.config/google-chrome-unstable

whitelist ${HOME}/.config/chrome-unstable-flags.conf
whitelist ${HOME}/.config/chrome-unstable-flags.config

# Redirect
include chromium-common.profile
