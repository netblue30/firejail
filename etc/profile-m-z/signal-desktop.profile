# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include signal-desktop.local
# Persistent global definitions
include globals.local

ignore novideo

ignore noexec /tmp

noblacklist ${HOME}/.config/Signal

# These lines are needed to allow Firefox to open links
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.config/Signal
whitelist ${HOME}/.config/Signal

private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,machine-id,nsswitch.conf,pki,resolv.conf,ssl

dbus-user filter

# allow D-Bus notifications
dbus-user.talk org.freedesktop.Notifications

# allow D-Bus communication with Firefox browsers for opening links
dbus-user.talk org.mozilla.*

ignore dbus-user none

# Redirect
include electron.profile
