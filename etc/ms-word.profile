# Firejail profile for Microsoft Office Online - Word
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ms-word.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/ms-word-online
private-bin ms-word

# Redirect
include /etc/firejail/ms-office.profile
