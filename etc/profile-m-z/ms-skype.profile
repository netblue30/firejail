# Firejail profile for Microsoft Office Online - Skype
# This file is overwritten after every install/update
# Persistent local customizations
include ms-skype.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore novideo

nodeny  ${HOME}/.cache/ms-skype-online

private-bin ms-skype

# Redirect
include ms-office.profile
