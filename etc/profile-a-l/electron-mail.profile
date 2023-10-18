# Firejail profile for ElectronMail
# Description: Unofficial desktop app for the Proton Mail E2E encrypted email provider
# This file is overwritten after every install/update
# Persistent local customizations
include electron-mail.local
# Persistent global definitions
include globals.local

ignore dbus-user none
ignore disable-mnt

noblacklist ${HOME}/.config/electron-mail

# sh is needed to allow Firefox to open links
include allow-bin-sh.inc

include disable-shell.inc

mkdir ${HOME}/.config/electron-mail
whitelist ${HOME}/.config/electron-mail
whitelist /opt/ElectronMail

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

machine-id
nosound

private-etc @tls-ca,@x11

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.SystemPrompter
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*

# Redirect
include electron-common.profile
