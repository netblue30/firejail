# Firejail profile for yandex-browser
# This file is overwritten after every install/update
# Persistent local customizations
include yandex-browser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/yandex-browser
noblacklist ${HOME}/.cache/yandex-browser-beta
noblacklist ${HOME}/.config/yandex-browser
noblacklist ${HOME}/.config/yandex-browser-beta

mkdir ${HOME}/.cache/yandex-browser
mkdir ${HOME}/.cache/yandex-browser-beta
mkdir ${HOME}/.config/yandex-browser
mkdir ${HOME}/.config/yandex-browser-beta
whitelist ${HOME}/.cache/yandex-browser
whitelist ${HOME}/.cache/yandex-browser-beta
whitelist ${HOME}/.config/yandex-browser
whitelist ${HOME}/.config/yandex-browser-beta

# Redirect
include chromium-common.profile
