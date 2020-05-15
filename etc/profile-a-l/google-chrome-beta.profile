# Firejail profile for google-chrome-beta
# This file is overwritten after every install/update
# Persistent local customizations
include google-chrome-beta.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/google-chrome-beta
noblacklist ${HOME}/.config/google-chrome-beta

noblacklist ${HOME}/.config/chrome-beta-flags.conf
noblacklist ${HOME}/.config/chrome-beta-flags.config

mkdir ${HOME}/.cache/google-chrome-beta
mkdir ${HOME}/.config/google-chrome-beta
whitelist ${HOME}/.cache/google-chrome-beta
whitelist ${HOME}/.config/google-chrome-beta

whitelist ${HOME}/.config/chrome-beta-flags.conf
whitelist ${HOME}/.config/chrome-beta-flags.config

# Redirect
include chromium-common.profile
