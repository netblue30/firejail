# Firejail profile for min
# Description: A faster, smarter web browser.
# This file is overwritten after every install/update
# Persistent local customizations
include min.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/Min

mkdir ${HOME}/.config/Min
allow  ${HOME}/.config/Min

# Redirect
include chromium-common.profile
