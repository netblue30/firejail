# Firejail profile for discord-canary
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/discord-canary.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.config/discordcanary

mkdir ${HOME}/.config/discordcanary
whitelist ${HOME}/.config/discordcanary

private-bin discord-canary
private-opt discord-canary

#Redirect
include /etc/firejail/discord-common.profile
