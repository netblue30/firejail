# Firejail profile for vivaldi
# This file is overwritten after every install/update
# Persistent local customizations
include vivaldi.local
# Persistent global definitions
include globals.local

# Allow HTML5 Proprietary Media & DRM/EME (Widevine)
?BROWSER_ALLOW_DRM: ignore apparmor
?BROWSER_ALLOW_DRM: ignore noexec /var
?BROWSER_ALLOW_DRM: noblacklist /var/opt
?BROWSER_ALLOW_DRM: whitelist /var/opt/vivaldi
?BROWSER_ALLOW_DRM: writable-var

noblacklist ${HOME}/.cache/vivaldi
noblacklist ${HOME}/.cache/vivaldi-snapshot
noblacklist ${HOME}/.config/vivaldi
noblacklist ${HOME}/.config/vivaldi-snapshot
noblacklist ${HOME}/.local/lib/vivaldi

mkdir ${HOME}/.cache/vivaldi
mkdir ${HOME}/.cache/vivaldi-snapshot
mkdir ${HOME}/.config/vivaldi
mkdir ${HOME}/.config/vivaldi-snapshot
mkdir ${HOME}/.local/lib/vivaldi
whitelist ${HOME}/.cache/vivaldi
whitelist ${HOME}/.cache/vivaldi-snapshot
whitelist ${HOME}/.config/vivaldi
whitelist ${HOME}/.config/vivaldi-snapshot
whitelist ${HOME}/.local/lib/vivaldi

# breaks vivaldi sync
ignore dbus-user none
ignore dbus-system none

# Redirect
include chromium-common.profile
