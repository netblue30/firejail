# Firejail profile for vivaldi
# This file is overwritten after every install/update
# Persistent local customizations
include vivaldi.local
# Persistent global definitions
include globals.local

# Allow HTML5 Proprietary Media & DRM/EME (Widevine)
ignore apparmor
ignore noexec /var
nodeny  /var/opt
allow  /var/opt/vivaldi
writable-var

nodeny  ${HOME}/.cache/vivaldi
nodeny  ${HOME}/.cache/vivaldi-snapshot
nodeny  ${HOME}/.config/vivaldi
nodeny  ${HOME}/.config/vivaldi-snapshot
nodeny  ${HOME}/.local/lib/vivaldi

mkdir ${HOME}/.cache/vivaldi
mkdir ${HOME}/.cache/vivaldi-snapshot
mkdir ${HOME}/.config/vivaldi
mkdir ${HOME}/.config/vivaldi-snapshot
mkdir ${HOME}/.local/lib/vivaldi
allow  ${HOME}/.cache/vivaldi
allow  ${HOME}/.cache/vivaldi-snapshot
allow  ${HOME}/.config/vivaldi
allow  ${HOME}/.config/vivaldi-snapshot
allow  ${HOME}/.local/lib/vivaldi

#private-bin bash,cat,dirname,readlink,rm,vivaldi,vivaldi-stable,vivaldi-snapshot

# breaks vivaldi sync
ignore dbus-user none
ignore dbus-system none

read-write ${HOME}/.local/lib/vivaldi

# Redirect
include chromium-common.profile
