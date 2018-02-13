# Firejail profile for opera
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/opera.local
# Persistent global definitions
include /etc/firejail/globals.local

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
include /etc/firejail/chromium-common.profile
