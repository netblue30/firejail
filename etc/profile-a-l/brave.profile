# Firejail profile for brave
# Description: Web browser that blocks ads and trackers by default.
# This file is overwritten after every install/update
# Persistent local customizations
include brave.local
# Persistent global definitions
include globals.local

# noexec /tmp is included in chromium-common.profile and breaks Brave
ignore noexec /tmp
# TOR is installed in ${HOME}. Note that this breaks when enabling apparmor in the included
# chromium-common.profile _without_ uncommenting the relevant rule in your
# /etc/apparmor.d/local/firejail-default.
ignore noexec ${HOME}

noblacklist ${HOME}/.cache/BraveSoftware
noblacklist ${HOME}/.config/BraveSoftware
noblacklist ${HOME}/.config/brave
noblacklist ${HOME}/.config/brave-flags.conf
# brave uses gpg for built-in password manager
noblacklist ${HOME}/.gnupg

mkdir ${HOME}/.cache/BraveSoftware
mkdir ${HOME}/.config/BraveSoftware
mkdir ${HOME}/.config/brave
whitelist ${HOME}/.cache/BraveSoftware
whitelist ${HOME}/.config/BraveSoftware
whitelist ${HOME}/.config/brave
whitelist ${HOME}/.config/brave-flags.conf
whitelist ${HOME}/.gnupg

# Brave sandbox needs read access to /proc/config.gz
noblacklist /proc/config.gz

# Redirect
include chromium-common.profile
