# Firejail profile for mattermost-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include mattermost-desktop.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore apparmor
ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/Mattermost

include disable-shell.inc

mkdir ${HOME}/.config/Mattermost
whitelist ${HOME}/.config/Mattermost

private-etc @tls-ca

# Not tested
#dbus-user filter
#dbus-user.own com.mattermost.Desktop
#dbus-user.talk org.freedesktop.Notifications
#dbus-system none

# Redirect
include electron-common.profile
