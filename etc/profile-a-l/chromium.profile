# Firejail profile for chromium
# Description: A web browser built for speed, simplicity, and security
# This file is overwritten after every install/update
# Persistent local customizations
include chromium.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/chromium
nodeny  ${HOME}/.config/chromium
nodeny  ${HOME}/.config/chromium-flags.conf

mkdir ${HOME}/.cache/chromium
mkdir ${HOME}/.config/chromium
allow  ${HOME}/.cache/chromium
allow  ${HOME}/.config/chromium
allow  ${HOME}/.config/chromium-flags.conf
allow  /usr/share/chromium
allow  /usr/share/mozilla/extensions

# private-bin chromium,chromium-browser,chromedriver

# Redirect
include chromium-common.profile
