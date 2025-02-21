# Firejail profile for vesktop
# Description: A custom Discord client
# This file is overwritten after every install/update
# Persistent local customizations
include vesktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/vesktop

mkdir ${HOME}/.config/vesktop
whitelist ${HOME}/.config/vesktop

private-bin vesktop

ignore join-or-start discord
join-or-start vesktop

# Redirect
include discord-common.profile
