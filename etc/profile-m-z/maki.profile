# Firejail profile for maki
# Description: Agentic coding tool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include maki.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/maki
noblacklist ${HOME}/.config/maki
noblacklist ${HOME}/.local/logs/maki
noblacklist ${HOME}/.local/share/maki
noblacklist ${HOME}/.local/state/maki

# Redirect
include llm-agent-common.profile
