# Firejail profile for enox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/enox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/Enox
noblacklist ${HOME}/.config/Enox

mkdir ${HOME}/.cache/dnox
mkdir ${HOME}/.config/dnox
mkdir ${HOME}/.cache/Enox
mkdir ${HOME}/.config/Enox
whitelist ${HOME}/.cache/Enox
whitelist ${HOME}/.config/Enox

# Redirect
include /etc/firejail/chromium-common.profile
