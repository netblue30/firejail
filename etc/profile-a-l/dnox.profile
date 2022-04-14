# Firejail profile for dnox
# This file is overwritten after every install/update
# Persistent local customizations
include dnox.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/mozilla/extensions
ignore whitelist /usr/share/webext
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

noblacklist ${HOME}/.cache/dnox
noblacklist ${HOME}/.config/dnox

mkdir ${HOME}/.cache/dnox
mkdir ${HOME}/.config/dnox
whitelist ${HOME}/.cache/dnox
whitelist ${HOME}/.config/dnox

# Redirect
include chromium-common.profile
