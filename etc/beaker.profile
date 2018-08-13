# Firejail profile for beaker
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/beaker.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Beaker Browser

include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc

mkdir ${HOME}/.config/Beaker Browser
whitelist ${HOME}/.config/Beaker Browser
whitelist ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc

# Redirect
include /etc/firejail/electron.profile
