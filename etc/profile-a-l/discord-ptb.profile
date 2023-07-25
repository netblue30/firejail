# Firejail profile for discord-ptb
# This file is overwritten after every install/update
# Persistent local customizations
include discord-ptb.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/discordptb

mkdir ${HOME}/.config/discordptb
whitelist ${HOME}/.config/discordptb

private-bin discord-ptb,DiscordPTB
private-opt discord-ptb,DiscordPTB

# Redirect
include discord-common.profile
