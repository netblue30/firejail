# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include signal-desktop.local
# Persistent global definitions
include globals.local

# sh is needed to allow Firefox to open links
include allow-bin-sh.inc

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
# Allow D-Bus communication with Firefox for opening links
dbus-user.talk org.mozilla.*

ignore dbus-user none

# Redirect
include electron-common.profile
