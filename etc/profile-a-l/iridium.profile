# Firejail profile for iridium
# This file is overwritten after every install/update
# Persistent local customizations
include iridium.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

nodeny  ${HOME}/.cache/iridium
nodeny  ${HOME}/.config/iridium

mkdir ${HOME}/.cache/iridium
mkdir ${HOME}/.config/iridium
allow  ${HOME}/.cache/iridium
allow  ${HOME}/.config/iridium

# Redirect
include chromium-common.profile
