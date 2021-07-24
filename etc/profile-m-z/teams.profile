# Firejail profile for teams
# Description: Official Microsoft Teams client for Linux using Electron.
# This file is overwritten after every install/update
# Persistent local customizations
include teams.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include disable-xdg.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore novideo
ignore private-tmp

# see #3404
ignore apparmor
ignore dbus-user none
ignore dbus-system none

nodeny  ${HOME}/.config/teams
nodeny  ${HOME}/.config/Microsoft

mkdir ${HOME}/.config/teams
mkdir ${HOME}/.config/Microsoft
allow  ${HOME}/.config/teams
allow  ${HOME}/.config/Microsoft

# Redirect
include electron.profile
