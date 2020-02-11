# Firejail profile for teams
# Description: Official Microsoft Teams client for Linux using Electron.
# This file is overwritten after every install/update
# Persistent local customizations
include teams.local
# Persistent global definitions
# added by included profile
#include globals.local

# TODO add these 2 paths as blacklist to disable-programs.inc
noblacklist ${HOME}/.config/teams
noblacklist ${HOME}/.config/Microsoft

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc

mkdir ${HOME}/.config/teams
mkdir ${HOME}/.config/Microsoft
whitelist ${HOME}/.config/teams
whitelist ${HOME}/.config/Microsoft
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc
# TODO Check if can we enable wusc - if so, do we need to whitelist something in /usr/share/?
#include whitelist-usr-share-common.inc

nou2f
shell none
# TODO Check if can we enable tracelog?
#tracelog

disable-mnt
private-cache
private-dev
private-tmp

# Redirect
include electron.profile
