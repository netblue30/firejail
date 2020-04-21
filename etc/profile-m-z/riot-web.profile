# Firejail profile for riot-web
# Description: A glossy Matrix collaboration client for the web
# This file is overwritten after every install/update
# Persistent local customizations
include riot-web.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/Riot

mkdir ${HOME}/.config/Riot
whitelist ${HOME}/.config/Riot
include whitelist-common.inc

# Redirect
include electron.profile
