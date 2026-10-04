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
# Note: chromium-common.profile enables apparmor. To keep that intact,
# uncomment the 'brave + tor' rule in /etc/apparmor.d/local/firejail-default.
# Alternatively you can add 'ignore apparmor' to your brave.local.
ignore noexec ${HOME}

# Causes slow starts (#4604)
# ignore private-cache
# The fix to #4604 was to disable private-cache with the ignore
# statement above. However, the fix is from Oct 2021. I think
# it is worth (Oct 2026 now) trying again with a private cache.
# This problem was only seen on Brave, all other chromium-based
# browsers don't have this problem.

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

# mpris
dbus-user.own org.mpris.MediaPlayer2.brave.*

# Redirect
include chromium-common.profile
