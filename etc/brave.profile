# Firejail profile for brave
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/brave.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/brave
# brave uses gpg for built-in password manager
noblacklist ${HOME}/.gnupg

mkdir ${HOME}/.config/brave
whitelist ${HOME}/.config/brave
whitelist ${HOME}/.gnupg

# noexec /tmp is included in chromium-common.profile and breaks Brave
ignore noexec /tmp

# Redirect
include /etc/firejail/chromium-common.profile
