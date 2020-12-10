# Firejail profile for beaker
# This file is overwritten after every install/update
# Persistent local customizations
include beaker.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Beaker Browser

include disable-devel.inc
include disable-interpreters.inc

mkdir ${HOME}/.config/Beaker Browser
whitelist ${HOME}/.config/Beaker Browser

# Redirect
include electron.profile
