# Firejail profile for npm
# Description: The Node.js Package Manager
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include npm.local
# Persistent global definitions
include globals.local

ignore read-only ${HOME}/.npm-packages
ignore read-only ${HOME}/.npmrc

noblacklist ${HOME}/.node-gyp
noblacklist ${HOME}/.npm
noblacklist ${HOME}/.npmrc

# If you want whitelisting, change ${HOME}/Projects below to your npm projects directory
# and add the next lines to your npm.local.
#mkdir ${HOME}/.node-gyp
#mkdir ${HOME}/.npm
#mkfile ${HOME}/.npmrc
#whitelist ${HOME}/.node-gyp
#whitelist ${HOME}/.npm
#whitelist ${HOME}/.npmrc
#whitelist ${HOME}/Projects
#include whitelist-common.inc

# Redirect
include nodejs-common.profile
