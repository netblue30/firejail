# Firejail profile for bnox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bnox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/bnox
noblacklist ${HOME}/.config/bnox

mkdir ${HOME}/.cache/bnox
mkdir ${HOME}/.config/bnox
whitelist ${HOME}/.cache/bnox
whitelist ${HOME}/.config/bnox

# Redirect
include /etc/firejail/chromium-common.profile
