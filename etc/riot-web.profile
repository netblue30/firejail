# Firejail profile for riot-web
# Description: A glossy Matrix collaboration client for the web
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/riot-web.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Riot

mkdir ${HOME}/.config/Riot
whitelist ${HOME}/.config/Riot
include /etc/firejail/whitelist-common.inc

# Redirect
include /etc/firejail/electron.profile
