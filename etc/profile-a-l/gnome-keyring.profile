# Firejail profile for gnome-keyring
# Description: Stores passwords and encryption keys
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-keyring.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.gnupg

mkdir ${HOME}/.gnupg
whitelist ${HOME}/.gnupg
whitelist ${DOWNLOADS}

# Redirect
include gnome-keyring-daemon.profile
