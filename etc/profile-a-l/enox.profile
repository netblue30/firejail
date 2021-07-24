# Firejail profile for enox
# This file is overwritten after every install/update
# Persistent local customizations
include enox.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

nodeny  ${HOME}/.cache/Enox
nodeny  ${HOME}/.config/Enox

#mkdir ${HOME}/.cache/dnox
#mkdir ${HOME}/.config/dnox
mkdir ${HOME}/.cache/Enox
mkdir ${HOME}/.config/Enox
allow  ${HOME}/.cache/Enox
allow  ${HOME}/.config/Enox

# Redirect
include chromium-common.profile
