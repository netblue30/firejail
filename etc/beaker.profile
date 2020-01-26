# Firejail profile for beaker
# This file is overwritten after every install/update
# Persistent local customizations
include beaker.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/Beaker Browser

include disable-devel.inc
include disable-interpreters.inc

mkdir ${HOME}/.config/Beaker Browser
whitelist ${HOME}/.config/Beaker Browser
include whitelist-common.inc

# Redirect
include electron.profile
