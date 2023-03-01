# Firejail profile for tutanota-desktop
# Description: Encrypted email client
# This file is overwritten after every install/update
# Persistent local customizations
include tutanota-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/tuta_integration
noblacklist ${HOME}/.config/tutanota-desktop

ignore noexec /tmp

include disable-shell.inc

mkdir ${HOME}/.config/tuta_integration
mkdir ${HOME}/.config/tutanota-desktop
whitelist ${HOME}/.config/tuta_integration
whitelist ${HOME}/.config/tutanota-desktop

# These lines are needed to allow Firefox to open links
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.mozilla/firefox/profiles.ini

?HAS_APPIMAGE: ignore private-dev
private-etc @tls-ca
private-opt tutanota-desktop

# Redirect
include electron-common.profile
