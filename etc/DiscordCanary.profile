# Firejail profile for DiscordCanary
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/DiscordCanary.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.config/discordcanary

mkdir ${HOME}/.config/discordcanary
whitelist ${HOME}/.config/discordcanary

private-bin DiscordCanary
private-opt DiscordCanary

#Redirect
include /etc/firejail/discord-common.profile
