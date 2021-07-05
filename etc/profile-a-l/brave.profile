# Firejail profile for brave
# Description: Web browser that blocks ads and trackers by default.
# This file is overwritten after every install/update
# Persistent local customizations
include brave.local
# Persistent global definitions
include globals.local

# noexec /tmp is included in chromium-common.profile and breaks Brave
ignore noexec /tmp
# TOR is installed in ${HOME}.
# NOTE: chromium-common.profile enables apparmor. To keep that intact
# you will need to uncomment the 'brave + tor' rule in /etc/apparmor.d/local/firejail-default.
# Alternatively you can add 'ignore apparmor' to your brave.local.
ignore noexec ${HOME}

nodeny  ${HOME}/.cache/BraveSoftware
nodeny  ${HOME}/.config/BraveSoftware
nodeny  ${HOME}/.config/brave
nodeny  ${HOME}/.config/brave-flags.conf
# brave uses gpg for built-in password manager
nodeny  ${HOME}/.gnupg

mkdir ${HOME}/.cache/BraveSoftware
mkdir ${HOME}/.config/BraveSoftware
mkdir ${HOME}/.config/brave
allow  ${HOME}/.cache/BraveSoftware
allow  ${HOME}/.config/BraveSoftware
allow  ${HOME}/.config/brave
allow  ${HOME}/.config/brave-flags.conf
allow  ${HOME}/.gnupg

# Brave sandbox needs read access to /proc/config.gz
nodeny  /proc/config.gz

# Redirect
include chromium-common.profile
