# Firejail profile for google-chrome
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-chrome.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/google-chrome
noblacklist ${HOME}/.config/google-chrome

mkdir ${HOME}/.cache/google-chrome
mkdir ${HOME}/.config/google-chrome
whitelist ${HOME}/.cache/google-chrome
whitelist ${HOME}/.config/google-chrome

# Redirect
include /etc/firejail/chromium-common.profile
