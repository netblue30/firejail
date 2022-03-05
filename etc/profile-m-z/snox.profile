# Firejail profile for snox
# This file is overwritten after every install/update
# Persistent local customizations
include snox.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

noblacklist ${HOME}/.cache/snox
noblacklist ${HOME}/.config/snox

#mkdir ${HOME}/.cache/dnox
#mkdir ${HOME}/.config/dnox
mkdir ${HOME}/.cache/snox
mkdir ${HOME}/.config/snox
whitelist ${HOME}/.cache/snox
whitelist ${HOME}/.config/snox

# Redirect
include chromium-common.profile
