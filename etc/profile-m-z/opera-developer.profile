# Firejail profile for opera-developer
# This file is overwritten after every install/update
# Persistent local customizations
include opera-developer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/opera-developer
noblacklist ${HOME}/.config/opera-developer
noblacklist ${HOME}/.opera-developer

mkdir ${HOME}/.cache/opera-developer
mkdir ${HOME}/.config/opera-developer
mkdir ${HOME}/.opera-developer
whitelist ${HOME}/.cache/opera-developer
whitelist ${HOME}/.config/opera-developer
whitelist ${HOME}/.opera-developer

# Redirect
include chromium-common.profile
