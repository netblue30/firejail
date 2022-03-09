# Firejail profile for skypeforlinux
# This file is overwritten after every install/update
# Persistent local customizations
include skypeforlinux.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc
ignore nou2f

# breaks Skype
ignore apparmor
ignore dbus-user none
ignore noexec /tmp
ignore novideo
ignore private-dev # needs /dev/disk

noblacklist ${HOME}/.config/skypeforlinux

mkdir ${HOME}/.config/skypeforlinux
whitelist ${HOME}/.config/skypeforlinux

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
# Note: Skype will log out the current session on start-up without this:
dbus-user.talk org.kde.StatusNotifierWatcher

# Redirect
include electron.profile
