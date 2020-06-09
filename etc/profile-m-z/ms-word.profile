# Firejail profile for Microsoft Office Online - Word
# This file is overwritten after every install/update
# Persistent local customizations
include ms-word.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/ms-word-online
private-bin ms-word

# Redirect
include ms-office.profile
