# Firejail profile for iridium
# This file is overwritten after every install/update
# Persistent local customizations
include iridium.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/iridium
noblacklist ${HOME}/.config/iridium

mkdir ${HOME}/.cache/iridium
mkdir ${HOME}/.config/iridium
whitelist ${HOME}/.cache/iridium
whitelist ${HOME}/.config/iridium

# Redirect
include chromium-common.profile
