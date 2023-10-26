# Firejail profile for discord-ptb
# This file is overwritten after every install/update
# Persistent local customizations
include discord-ptb.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/discordptb

mkdir ${HOME}/.config/discordptb
whitelist ${HOME}/.config/discordptb
whitelist /opt/DiscordPTB
whitelist /opt/discord

private-bin DiscordPTB,discord-ptb

# Redirect
include discord-common.profile
