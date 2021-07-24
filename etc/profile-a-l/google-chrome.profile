# Firejail profile for google-chrome
# This file is overwritten after every install/update
# Persistent local customizations
include google-chrome.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/chromium
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

nodeny  ${HOME}/.cache/google-chrome
nodeny  ${HOME}/.config/google-chrome

nodeny  ${HOME}/.config/chrome-flags.conf
nodeny  ${HOME}/.config/chrome-flags.config

mkdir ${HOME}/.cache/google-chrome
mkdir ${HOME}/.config/google-chrome
allow  ${HOME}/.cache/google-chrome
allow  ${HOME}/.config/google-chrome

allow  ${HOME}/.config/chrome-flags.conf
allow  ${HOME}/.config/chrome-flags.config

# Redirect
include chromium-common.profile
