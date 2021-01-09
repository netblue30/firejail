# Firejail profile for npm
# Description: The Node.js Package Manager
# This file is overwritten after every install/update
# Persistent local customizations
include npm.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.node-gyp
noblacklist ${HOME}/.npm
noblacklist ${HOME}/.npmrc
ignore read-only ${HOME}/.npm-packages
ignore read-only ${HOME}/.npmrc

# If you want whitelisting, change ${HOME}/Projects below to your npm projects directory
# and uncomment the lines below.
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
