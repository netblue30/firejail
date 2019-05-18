# Firejail profile for eom
# Description: Eye of MATE graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mate/eom

# Redirect
include eo-common.profile
