# Firejail profile for vivaldi
# This file is overwritten after every install/update
# Persistent local customizations
include vivaldi.local
# Persistent global definitions
include globals.local

# Allow HTML5 Proprietary Media & DRM/EME (Widevine)
ignore apparmor
ignore noexec /var
noblacklist /var/opt
whitelist /var/opt/vivaldi
writable-var

noblacklist ${HOME}/.cache/vivaldi
noblacklist ${HOME}/.config/vivaldi
noblacklist ${HOME}/.local/lib/vivaldi

mkdir ${HOME}/.cache/vivaldi
mkdir ${HOME}/.config/vivaldi
mkdir ${HOME}/.local/lib/vivaldi
whitelist ${HOME}/.cache/vivaldi
whitelist ${HOME}/.config/vivaldi
whitelist ${HOME}/.local/lib/vivaldi

# Add the next line to your vivaldi.local to enable private-bin.
#private-bin bash,cat,dirname,readlink,rm,vivaldi

# vivaldi sync needs full D-Bus access
ignore dbus-user none
ignore dbus-system none

read-write ${HOME}/.local/lib/vivaldi

# Redirect
include chromium-common.profile
