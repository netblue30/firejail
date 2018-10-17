# Firejail profile for Microsoft Office Online - Powerpoint
# This file is overwritten after every install/update
# Persistent local customizations
include ms-powerpoint.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/ms-powerpoint-online
private-bin ms-powerpoint

# Redirect
include ms-office.profile
