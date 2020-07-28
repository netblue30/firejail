# Firejail profile for opera
# Description: A fast and secure web browser
# This file is overwritten after every install/update
# Persistent local customizations
include opera.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/opera
noblacklist ${HOME}/.config/opera
noblacklist ${HOME}/.opera

mkdir ${HOME}/.cache/opera
mkdir ${HOME}/.config/opera
mkdir ${HOME}/.opera
whitelist ${HOME}/.cache/opera
whitelist ${HOME}/.config/opera
whitelist ${HOME}/.opera

# Redirect
include chromium-common.profile
