# Firejail profile for inox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/inox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/inox
noblacklist ${HOME}/.config/inox

mkdir ${HOME}/.cache/inox
mkdir ${HOME}/.config/inox
whitelist ${HOME}/.cache/inox
whitelist ${HOME}/.config/inox

# Redirect
include /etc/firejail/chromium-common.profile
