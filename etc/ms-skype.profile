# Firejail profile for Microsoft Office Online - Skype
# This file is overwritten after every install/update
# Persistent local customizations
include ms-skype.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/ms-skype-online
ignore novideo
private-bin ms-skype

# Redirect
include ms-office.profile
