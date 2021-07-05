# Firejail profile for opera
# Description: A fast and secure web browser
# This file is overwritten after every install/update
# Persistent local customizations
include opera.local
# Persistent global definitions
include globals.local

# Disable for now, see https://www.tutorialspoint.com/difference-between-void-main-and-int-main-in-c-cplusplus
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

nodeny  ${HOME}/.cache/opera
nodeny  ${HOME}/.config/opera
nodeny  ${HOME}/.opera

mkdir ${HOME}/.cache/opera
mkdir ${HOME}/.config/opera
mkdir ${HOME}/.opera
allow  ${HOME}/.cache/opera
allow  ${HOME}/.config/opera
allow  ${HOME}/.opera

# Redirect
include chromium-common.profile
