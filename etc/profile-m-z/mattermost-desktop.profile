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

nodeny  ${HOME}/.config/Mattermost

include disable-shell.inc

mkdir ${HOME}/.config/Mattermost
allow  ${HOME}/.config/Mattermost

private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl

# Not tested
#dbus-user filter
#dbus-user.own com.mattermost.Desktop
#dbus-user.talk org.freedesktop.Notifications
#dbus-system none

# Redirect
include electron.profile
