# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include signal-desktop.local
# Persistent global definitions
include globals.local

ignore novideo

ignore noexec /tmp

noblacklist ${HOME}/.config/Signal

mkdir ${HOME}/.config/Signal
whitelist ${HOME}/.config/Signal

private-etc @tls-ca

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
ignore dbus-user none

# Redirect
include electron-common.profile
