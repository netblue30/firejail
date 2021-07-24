# Firejail profile for Microsoft Office Online - Onenote
# This file is overwritten after every install/update
# Persistent local customizations
include ms-onenote.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.cache/ms-onenote-online
private-bin ms-onenote

# Redirect
include ms-office.profile
