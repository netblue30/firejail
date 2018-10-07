# Firejail profile for discord
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/discord.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.config/discord

mkdir ${HOME}/.config/discord
whitelist ${HOME}/.config/discord

private-bin discord
private-opt discord

#Redirect
include /etc/firejail/discord-common.profile
