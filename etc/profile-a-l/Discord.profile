# Firejail profile for Discord
# This file is overwritten after every install/update
# Persistent local customizations
include Discord.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/discord

mkdir ${HOME}/.config/discord
allow  ${HOME}/.config/discord

private-bin Discord
private-opt Discord

# Redirect
include discord-common.profile
