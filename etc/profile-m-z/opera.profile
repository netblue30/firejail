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

# https://github.com/netblue30/firejail/issues/4965
ignore whitelist /usr/share/mozilla/extensions
ignore whitelist /usr/share/webext

# opera uses opera_sandbox instead of chrome-sandbox
noblacklist /usr/lib/opera/opera_sandbox
ignore noblacklist /usr/lib/chromium/chrome-sandbox

# Add the below to your opera.local if you want to disable auto update
#env OPERA_AUTOUPDATE_DISABLED=1

# Redirect
include chromium-common.profile
