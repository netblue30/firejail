# Firejail profile for opera-beta
# This file is overwritten after every install/update
# Persistent local customizations
include opera-beta.local
# Persistent global definitions
include globals.local

# Disable for now, see https://www.tutorialspoint.com/difference-between-void-main-and-int-main-in-c-cplusplus
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

noblacklist ${HOME}/.cache/opera
noblacklist ${HOME}/.config/opera-beta

mkdir ${HOME}/.cache/opera
mkdir ${HOME}/.config/opera-beta
whitelist ${HOME}/.cache/opera
whitelist ${HOME}/.config/opera-beta

# Redirect
include chromium-common.profile
