# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include signal-desktop.local
# Persistent global definitions
include globals.local

ignore novideo

ignore noexec /tmp

noblacklist ${HOME}/.config/Signal

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.config/Signal
whitelist ${HOME}/.config/Signal

private-etc @tls-ca

dbus-user filter
# allow D-Bus notifications
dbus-user.talk org.freedesktop.Notifications
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*

ignore dbus-user none

# Redirect
include electron-common.profile
