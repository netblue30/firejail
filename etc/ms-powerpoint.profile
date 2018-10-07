# Firejail profile for Microsoft Office Online - Powerpoint
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ms-powerpoint.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/ms-powerpoint-online
private-bin ms-powerpoint

# Redirect
include /etc/firejail/ms-office.profile
