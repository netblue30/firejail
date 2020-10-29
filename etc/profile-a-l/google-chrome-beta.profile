# Firejail profile for google-chrome-beta
# This file is overwritten after every install/update
# Persistent local customizations
include google-chrome-beta.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

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
