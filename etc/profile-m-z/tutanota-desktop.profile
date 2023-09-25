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

# sh is needed to allow Firefox to open links
include allow-bin-sh.inc

include disable-shell.inc

mkdir ${HOME}/.config/tuta_integration
mkdir ${HOME}/.config/tutanota-desktop
whitelist ${HOME}/.config/tuta_integration
whitelist ${HOME}/.config/tutanota-desktop
whitelist /opt/tutanota-desktop

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

machine-id
nosound

?HAS_APPIMAGE: ignore private-dev
private-etc @tls-ca

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.SystemPrompter
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*

# Redirect
include electron-common.profile
