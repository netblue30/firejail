# Firejail profile for matrix-mirage
# Description: Debian name for mirage binary/package
# This file is overwritten after every install/update
# Persistent local customizations
include matrix-mirage.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/matrix-mirage
noblacklist ${HOME}/.config/matrix-mirage
noblacklist ${HOME}/.local/share/matrix-mirage

mkdir ${HOME}/.cache/matrix-mirage
mkdir ${HOME}/.config/matrix-mirage
mkdir ${HOME}/.local/share/matrix-mirage
whitelist ${HOME}/.cache/matrix-mirage
whitelist ${HOME}/.config/matrix-mirage
whitelist ${HOME}/.local/share/matrix-mirage

private-bin matrix-mirage

# Redirect
include mirage.profile
