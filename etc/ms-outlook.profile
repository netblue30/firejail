# Firejail profile for Microsoft Office Online - Outlook
# This file is overwritten after every install/update
# Persistent local customizations
include ms-outlook.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/ms-outlook-online
private-bin ms-outlook

# Redirect
include ms-office.profile
