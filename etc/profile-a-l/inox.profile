# Firejail profile for inox
# This file is overwritten after every install/update
# Persistent local customizations
include inox.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/mozilla/extensions
ignore whitelist /usr/share/webext
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

noblacklist ${HOME}/.cache/inox
noblacklist ${HOME}/.config/inox

mkdir ${HOME}/.cache/inox
mkdir ${HOME}/.config/inox
whitelist ${HOME}/.cache/inox
whitelist ${HOME}/.config/inox

# Redirect
include chromium-common.profile
