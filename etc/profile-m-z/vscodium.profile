# Firejail profile alias for VSCodium
# This file is overwritten after every install/update
# Persistent local customizations
include vscodium.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.VSCodium
noblacklist ${HOME}/.config/VSCodium

# Redirect
include code.profile
