# Firejail profile for atom
# Description: A hackable text editor for the 21st Century
# This file is overwritten after every install/update
# Persistent local customizations
include atom.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include disable-devel.inc
ignore include disable-interpreters.inc
ignore include disable-xdg.inc
ignore whitelist ${DOWNLOADS}
ignore whitelist ${HOME}/.config/Electron
ignore whitelist ${HOME}/.config/electron*-flag*.conf
ignore include whitelist-common.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc
ignore apparmor
ignore disable-mnt

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom

# Allows files commonly used by IDEs
include allow-common-devel.inc

#net none
nosound

# Redirect
include electron-common.profile
