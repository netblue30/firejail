# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include signal-desktop.local
# Persistent global definitions
include globals.local

ignore novideo

ignore noexec /tmp

nodeny  ${HOME}/.config/Signal

# These lines are needed to allow Firefox to open links
nodeny  ${HOME}/.mozilla
allow  ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.config/Signal
allow  ${HOME}/.config/Signal

private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,machine-id,nsswitch.conf,pki,resolv.conf,ssl

# allow D-Bus notifications
dbus-user filter
dbus-user.talk org.freedesktop.Notifications
ignore dbus-user none

# Redirect
include electron.profile
