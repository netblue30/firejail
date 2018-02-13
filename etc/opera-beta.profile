# Firejail profile for opera-beta
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/opera-beta.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/opera
noblacklist ${HOME}/.config/opera-beta

mkdir ${HOME}/.cache/opera
mkdir ${HOME}/.config/opera-beta
whitelist ${HOME}/.cache/opera
whitelist ${HOME}/.config/opera-beta

# Redirect
include /etc/firejail/chromium-common.profile
