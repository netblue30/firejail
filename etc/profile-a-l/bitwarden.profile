# Firejail profile for bitwarden
# Description: A secure and free password manager for all of your devices
# This file is overwritten after every install/update.
# Persistent local customisations
include bitwarden.local
# Persistent global definitions
include globals.local

ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore disable-mnt
ignore dbus-user none
ignore dbus-system none

ignore noexec /tmp

noblacklist ${HOME}/.config/Bitwarden

include disable-shell.inc

mkdir ${HOME}/.config/Bitwarden
whitelist ${HOME}/.config/Bitwarden

machine-id
no3d
nosound

?HAS_APPIMAGE: ignore private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,hosts,nsswitch.conf,pki,resolv.conf,ssl
private-opt Bitwarden

# Redirect
include electron.profile
