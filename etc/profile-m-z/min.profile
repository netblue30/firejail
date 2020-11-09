# Firejail profile for min
# Description: A faster, smarter web browser.
# This file is overwritten after every install/update
# Persistent local customizations
include min.local
# Persistent global definitions
include globals.local

# Disable for now, see https://github.com/netblue30/firejail/pull/3688#issuecomment-718711565
ignore whitelist /usr/share/chromium

noblacklist ${HOME}/.config/Min

mkdir ${HOME}/.config/Min
whitelist ${HOME}/.config/Min

# Redirect
include chromium-common.profile
