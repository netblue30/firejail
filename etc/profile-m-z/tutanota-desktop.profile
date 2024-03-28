# Firejail profile for tutanota-desktop
# Description: Official desktop client for the Tutanota E2E encrypted email provider
# This file is overwritten after every install/update
# Persistent local customizations
include tutanota-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/tuta_integration
noblacklist ${HOME}/.config/tutanota-desktop

ignore dbus-user none
ignore disable-mnt
ignore noexec /tmp

include disable-shell.inc

mkdir ${HOME}/.config/tuta_integration
mkdir ${HOME}/.config/tutanota-desktop
whitelist ${HOME}/.config/tuta_integration
whitelist ${HOME}/.config/tutanota-desktop
whitelist /opt/tutanota-desktop

machine-id
nosound

?HAS_APPIMAGE: ignore private-dev
private-etc @tls-ca

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.SystemPrompter

# Redirect
include electron-common.profile
