# Firejail profile for bitwarden
# Description: A secure and free password manager for all of your devices
# This file is overwritten after every install/update.
# Persistent local customisations
include bitwarden.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include whitelist-usr-share-common.inc

ignore noexec /tmp

noblacklist ${HOME}/.config/Bitwarden

include disable-shell.inc

mkdir ${HOME}/.config/Bitwarden
whitelist ${HOME}/.config/Bitwarden
whitelist /opt/Bitwarden

machine-id
no3d
nosound

?HAS_APPIMAGE: ignore private-dev
private-etc @tls-ca

# Redirect
include electron-common.profile
