# Firejail profile for teams
# Description: Official Microsoft Teams client for Linux using Electron.
# This file is overwritten after every install/update
# Persistent local customizations
include teams.local
# Persistent global definitions
# added by included profile
#include globals.local

# see #3404
ignore apparmor
ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/teams
noblacklist ${HOME}/.config/Microsoft

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc

mkdir ${HOME}/.config/teams
mkdir ${HOME}/.config/Microsoft
whitelist ${HOME}/.config/teams
whitelist ${HOME}/.config/Microsoft
include whitelist-var-common.inc

nou2f
shell none

disable-mnt
private-cache
private-dev

# Redirect
include electron.profile
