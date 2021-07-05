# Firejail profile for DiscordCanary
# This file is overwritten after every install/update
# Persistent local customizations
include DiscordCanary.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/discordcanary

mkdir ${HOME}/.config/discordcanary
allow  ${HOME}/.config/discordcanary

private-bin DiscordCanary
private-opt DiscordCanary

# Redirect
include discord-common.profile
