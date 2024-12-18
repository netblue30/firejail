# Firejail profile for discord-canary
# This file is overwritten after every install/update
# Persistent local customizations
include discord-canary.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/discordcanary

mkdir ${HOME}/.config/discordcanary
whitelist ${HOME}/.config/discordcanary
whitelist /opt/DiscordCanary
whitelist /opt/discord-canary

private-bin DiscordCanary,discord-canary

# Redirect
include discord-common.profile
