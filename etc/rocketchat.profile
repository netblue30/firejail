# Firejail profile for rocketchat
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/rocketchat.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Rocket.Chat

whitelist ${HOME}/.config/Rocket.Chat
include /etc/firejail/whitelist-common.inc

# Redirect
include /etc/firejail/electron.profile
