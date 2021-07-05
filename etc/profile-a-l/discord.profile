# Firejail profile for discord
# This file is overwritten after every install/update
# Persistent local customizations
include discord.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/discord

mkdir ${HOME}/.config/discord
allow  ${HOME}/.config/discord

private-bin discord
private-opt discord

# Redirect
include discord-common.profile
