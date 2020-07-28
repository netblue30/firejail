# Firejail profile for min
# Description: A faster, smarter web browser.
# This file is overwritten after every install/update
# Persistent local customizations
include min.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Min

mkdir ${HOME}/.config/Min
whitelist ${HOME}/.config/Min

# Redirect
include chromium-common.profile
