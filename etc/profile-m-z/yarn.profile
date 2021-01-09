# Firejail profile for yarn
# Description: Fast, reliable, and secure dependency management
quiet
# Persistent local customizations
include yarn.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.yarn
noblacklist ${HOME}/.yarn-config
noblacklist ${HOME}/.yarncache
noblacklist ${HOME}/.yarnrc
ignore read-only ${HOME}/.yarnrc

# If you want whitelisting, change ${HOME}/Projects below to your yarn projects directory and uncomment the lines below.
#mkdir ${HOME}/.yarn
#mkdir ${HOME}/.yarn-config
#mkdir ${HOME}/.yarncache
#mkfile ${HOME}/.yarnrc
#whitelist ${HOME}/.yarn
#whitelist ${HOME}/.yarn-config
#whitelist ${HOME}/.yarncache
#whitelist ${HOME}/.yarnrc
#whitelist ${HOME}/Projects
#include whitelist-common.inc

# Redirect
include nodejs-common.profile
