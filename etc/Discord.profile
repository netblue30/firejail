# Firejail profile for Discord
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Discord.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.config/discord

mkdir ${HOME}/.config/discord
whitelist ${HOME}/.config/discord

private-bin Discord
private-opt Discord

#Redirect
include /etc/firejail/discord-common.profile
