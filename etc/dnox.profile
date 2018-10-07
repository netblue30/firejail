# Firejail profile for dnox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dnox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/dnox
noblacklist ${HOME}/.config/dnox

mkdir ${HOME}/.cache/dnox
mkdir ${HOME}/.config/dnox
whitelist ${HOME}/.cache/dnox
whitelist ${HOME}/.config/dnox

# Redirect
include /etc/firejail/chromium-common.profile
