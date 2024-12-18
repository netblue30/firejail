# Firejail profile for discord
# This file is overwritten after every install/update
# Persistent local customizations
include discord.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/discord

mkdir ${HOME}/.config/discord
whitelist ${HOME}/.config/discord
whitelist /opt/Discord
whitelist /opt/discord
whitelist /usr/share/discord

private-bin Discord,discord

# Redirect
include discord-common.profile
