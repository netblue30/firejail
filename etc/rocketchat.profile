# Firejail profile for rocketchat
# This file is overwritten after every install/update
# Persistent local customizations
include rocketchat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Rocket.Chat

mkdir ${HOME}/.config/Rocket.Chat
whitelist ${HOME}/.config/Rocket.Chat
include whitelist-common.inc

# Redirect
include electron.profile
