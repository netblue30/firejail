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

include disable-shell.inc

mkdir ${HOME}/.config/electron-mail
whitelist ${HOME}/.config/electron-mail
whitelist /opt/ElectronMail

machine-id
nosound

private-etc @tls-ca,@x11

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.SystemPrompter

# Redirect
include electron-common.profile
