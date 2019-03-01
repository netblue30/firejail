# Firejail profile for seahorse
# Description: GNOME application for managing PGP keys
# This file is overwritten after every install/update
# Persistent local customizations
include seahorse.local
# Persistent global definitions
# added by included profile
#include globals.local

# dconf
mkdir ${HOME}/.config/dconf
whitelist ${HOME}/.config/dconf

# ssh
noblacklist /etc/ssh
noblacklist /tmp/ssh-*
noblacklist ${HOME}/.ssh

include whitelist-var-common.inc

apparmor
ipc-namespace

# Redirect
include gpg.profile
