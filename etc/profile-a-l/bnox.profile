# Firejail profile for bnox
# This file is overwritten after every install/update
# Persistent local customizations
include bnox.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

nodeny  ${HOME}/.cache/bnox
nodeny  ${HOME}/.config/bnox

mkdir ${HOME}/.cache/bnox
mkdir ${HOME}/.config/bnox
allow  ${HOME}/.cache/bnox
allow  ${HOME}/.config/bnox

# Redirect
include chromium-common.profile
