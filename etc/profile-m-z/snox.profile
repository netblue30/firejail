# Firejail profile for snox
# This file is overwritten after every install/update
# Persistent local customizations
include snox.local
# Persistent global definitions
include globals.local

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
