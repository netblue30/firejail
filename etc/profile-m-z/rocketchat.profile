# Firejail profile for rocketchat
# This file is overwritten after every install/update
# Persistent local customizations
include rocketchat.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/Rocket.Chat

mkdir ${HOME}/.config/Rocket.Chat
whitelist ${HOME}/.config/Rocket.Chat

# Redirect
include electron.profile
