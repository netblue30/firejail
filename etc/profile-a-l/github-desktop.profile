# Firejail profile for github-desktop
# Description: Extend your GitHub workflow beyond your browser with GitHub Desktop
# This file is overwritten after every install/update
# Persistent local customizations
include github-desktop.local
# Persistent global definitions
include globals.local

# Note: On debian-based distributions the binary might be located in
# /opt/GitHub Desktop/github-desktop, and therefore not be in PATH.
# If that's the case you can start GitHub Desktop with firejail via
# `firejail "/opt/GitHub Desktop/github-desktop"`.

# Disabled until someone reported positive feedback
ignore include disable-xdg.inc
ignore whitelist ${DOWNLOADS}
ignore whitelist ${HOME}/.config/Electron
ignore whitelist ${HOME}/.config/electron*-flag*.conf
ignore include whitelist-common.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc
ignore apparmor
ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/GitHub Desktop
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials

#no3d
nosound

#private-bin github-desktop
?HAS_APPIMAGE: ignore private-dev
#private-lib

#memory-deny-write-execute

# Redirect
include electron-common.profile
