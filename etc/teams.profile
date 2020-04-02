# Firejail profile for teams
# Description: Official Microsoft Teams client for Linux using Electron.
# This file is overwritten after every install/update
# Known issues:
#  * if Teams crashes on startup try using "ignore apparmor" in your local config
# Persistent local customizations
include teams.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore nodbus

noblacklist ${HOME}/.config/teams
noblacklist ${HOME}/.config/Microsoft

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc

mkdir ${HOME}/.config/teams
mkdir ${HOME}/.config/Microsoft
whitelist ${HOME}/.config/teams
whitelist ${HOME}/.config/Microsoft
include whitelist-common.inc
include whitelist-var-common.inc

nou2f
shell none
tracelog

disable-mnt
private-cache
private-dev

# Redirect
include electron.profile
