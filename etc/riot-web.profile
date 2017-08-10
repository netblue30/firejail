# Firejail profile for riot-web
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/riot-web.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/Riot

whitelist ~/.config/Riot
include /etc/firejail/whitelist-common.inc

# Redirect
include /etc/firejail/electron.profile
