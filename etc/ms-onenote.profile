# Firejail profile for Microsoft Office Online - Onenote
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ms-onenote.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/ms-onenote-online
private-bin ms-onenote

# Redirect
include /etc/firejail/ms-office.profile
