# Firejail profile for pi
# Description: AI agent toolkit: coding agent CLI, unified LLM API, TUI & web UI libraries, Slack bot, vLLM pods
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include pi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.agents
noblacklist ${HOME}/.pi

# Add the following lines to pi.local to enable whitelisting in `${HOME}`.
#mkdir ${HOME}/.agents
#mkdir ${HOME}/.pi
#whitelist ${HOME}/.agents
#whitelist ${HOME}/.config/git
#whitelist ${HOME}/.gitconfig
#whitelist ${HOME}/.pi
#include whitelist-common.inc

# Redirect
include llm-agent-common.inc
