# Firejail profile for Microsoft Office Online - Outlook
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ms-outlook.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/ms-outlook-online
private-bin ms-outlook

# Redirect
include /etc/firejail/ms-office.profile
