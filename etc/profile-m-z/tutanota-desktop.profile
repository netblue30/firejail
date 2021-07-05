# Firejail profile for tutanota-desktop
# Description: Encrypted email client
# This file is overwritten after every install/update
# Persistent local customizations
include tutanota-desktop.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/tuta_integration
nodeny  ${HOME}/.config/tutanota-desktop

ignore noexec /tmp

include disable-shell.inc

mkdir ${HOME}/.config/tuta_integration
mkdir ${HOME}/.config/tutanota-desktop
allow  ${HOME}/.config/tuta_integration
allow  ${HOME}/.config/tutanota-desktop

# These lines are needed to allow Firefox to open links
nodeny  ${HOME}/.mozilla
allow  ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.mozilla/firefox/profiles.ini

?HAS_APPIMAGE: ignore private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl
private-opt tutanota-desktop

# Redirect
include electron.profile
