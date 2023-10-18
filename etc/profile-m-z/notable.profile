# Firejail profile for notable
# Description: The Markdown-based note-taking app that doesn't suck
# This file is overwritten after every install/update
# Persistent local customizations
include notable.local
# Persistent global definitions
include globals.local

# Note: On debian-based distributions the binary might be located in
# /opt/Notable/notable, and therefore not be in PATH.
# If that's the case you can start Notable with firejail via
# `firejail "/opt/Notable/notable"`.

noblacklist ${HOME}/.config/Notable
noblacklist ${HOME}/.notable

whitelist /opt/Notable

net none
nosound

?HAS_APPIMAGE: ignore private-dev

dbus-user filter
dbus-user.talk ca.desrt.dconf
ignore dbus-user none

# Notable keeps claiming it is started for the first time when whitelisting - see #4812.
ignore whitelist ${DOWNLOADS}
ignore whitelist ${HOME}/.config/Electron
ignore whitelist ${HOME}/.config/electron*-flag*.conf
ignore include whitelist-common.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc

# Redirect
include electron-common.profile
