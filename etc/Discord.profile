# Firejail profile for Discord
# This file is overwritten after every install/update
# Persistent local customizations
include Discord.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/discord

mkdir ${HOME}/.config/discord
whitelist ${HOME}/.config/discord

private-bin Discord
private-opt Discord

# Redirect
include discord-common.profile
