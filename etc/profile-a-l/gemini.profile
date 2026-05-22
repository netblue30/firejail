# Firejail profile for gemini
# Description: An open-source AI agent that brings the power of Gemini directly into your terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gemini.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gemini

# Add the following lines to gemini.local to enable whitelisting in `${HOME}`.
#mkdir ${HOME}/.gemini
#whitelist ${HOME}/.config/git
#whitelist ${HOME}/.gemini
#whitelist ${HOME}/.git-credential-cache
#whitelist ${HOME}/.git-credentials
#whitelist ${HOME}/.gitconfig
#include whitelist-common.inc

# Redirect
include llm-agent-common.profile
