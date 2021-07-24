# Firejail profile for inox
# This file is overwritten after every install/update
# Persistent local customizations
include inox.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

nodeny  ${HOME}/.cache/inox
nodeny  ${HOME}/.config/inox

mkdir ${HOME}/.cache/inox
mkdir ${HOME}/.config/inox
allow  ${HOME}/.cache/inox
allow  ${HOME}/.config/inox

# Redirect
include chromium-common.profile
