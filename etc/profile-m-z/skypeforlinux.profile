# Firejail profile for skypeforlinux
# This file is overwritten after every install/update
# Persistent local customizations
include skypeforlinux.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore whitelist ${DOWNLOADS}
ignore include whitelist-common.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc
ignore nou2f
ignore novideo
ignore private-dev
ignore dbus-user none
ignore dbus-system none

# breaks Skype
ignore apparmor
ignore noexec /tmp

noblacklist ${HOME}/.config/skypeforlinux

mkdir ${HOME}/.config/skypeforlinux
whitelist ${HOME}/.config/skypeforlinux

# private-dev - needs /dev/disk

# Redirect
include electron.profile
