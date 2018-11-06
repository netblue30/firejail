# Firejail profile for brave
# This file is overwritten after every install/update
# Description: Web browser that blocks ads and trackers by default.
# Persistent local customizations
include brave.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/brave
noblacklist ${HOME}/.config/BraveSoftware
# brave uses gpg for built-in password manager
noblacklist ${HOME}/.gnupg

mkdir ${HOME}/.config/brave
mkdir ${HOME}/.config/BraveSoftware
whitelist ${HOME}/.config/brave
whitelist ${HOME}/.config/BraveSoftware
whitelist ${HOME}/.gnupg

# noexec /tmp is included in chromium-common.profile and breaks Brave
ignore noexec /tmp

# Redirect
include chromium-common.profile
