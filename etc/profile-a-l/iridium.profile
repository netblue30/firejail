# Firejail profile for iridium
# This file is overwritten after every install/update
# Persistent local customizations
include iridium.local
# Persistent global definitions
include globals.local

# Disable for now, see ___
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

noblacklist ${HOME}/.cache/iridium
noblacklist ${HOME}/.config/iridium

mkdir ${HOME}/.cache/iridium
mkdir ${HOME}/.config/iridium
whitelist ${HOME}/.cache/iridium
whitelist ${HOME}/.config/iridium

# Redirect
include chromium-common.profile
