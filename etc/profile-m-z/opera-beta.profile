# Firejail profile for opera-beta
# This file is overwritten after every install/update
# Persistent local customizations
include opera-beta.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/opera-beta
noblacklist ${HOME}/.config/opera-beta
noblacklist ${HOME}/.opera-beta

mkdir ${HOME}/.cache/opera-beta
mkdir ${HOME}/.config/opera-beta
mkdir ${HOME}/.opera-beta
whitelist ${HOME}/.cache/opera-beta
whitelist ${HOME}/.config/opera-beta
whitelist ${HOME}/.opera-beta

# Redirect
include chromium-common.profile
