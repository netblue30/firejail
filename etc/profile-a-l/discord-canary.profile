# Firejail profile for discord-canary
# This file is overwritten after every install/update
# Persistent local customizations
include discord-canary.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/discordcanary

mkdir ${HOME}/.config/discordcanary
whitelist ${HOME}/.config/discordcanary

private-bin discord-canary,DiscordCanary
private-opt discord-canary,DiscordCanary

# Redirect
include discord-common.profile
