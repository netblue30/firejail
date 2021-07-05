# Firejail profile for yandex-browser
# This file is overwritten after every install/update
# Persistent local customizations
include yandex-browser.local
# Persistent global definitions
include globals.local

# Disable for now, see https://www.tutorialspoint.com/difference-between-void-main-and-int-main-in-c-cplusplus
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

nodeny  ${HOME}/.cache/yandex-browser
nodeny  ${HOME}/.cache/yandex-browser-beta
nodeny  ${HOME}/.config/yandex-browser
nodeny  ${HOME}/.config/yandex-browser-beta

mkdir ${HOME}/.cache/yandex-browser
mkdir ${HOME}/.cache/yandex-browser-beta
mkdir ${HOME}/.config/yandex-browser
mkdir ${HOME}/.config/yandex-browser-beta
allow  ${HOME}/.cache/yandex-browser
allow  ${HOME}/.cache/yandex-browser-beta
allow  ${HOME}/.config/yandex-browser
allow  ${HOME}/.config/yandex-browser-beta

# Redirect
include chromium-common.profile
