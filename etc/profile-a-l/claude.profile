# Firejail profile for claude
# Description: Agentic coding tool from Anthropic
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include claude.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.claude
noblacklist ${HOME}/.claude.json

# Add the following lines to claude.local to enable whitelisting in `${HOME}`.
#mkdir ${HOME}/.claude
#mkfile ${HOME}/.claude.json
#whitelist ${HOME}/.claude
#whitelist ${HOME}/.claude.json
#whitelist ${HOME}/.config/git
#whitelist ${HOME}/.gitconfig
#include whitelist-common.inc

# Redirect
include llm-agent-common.profile
