# Firejail profile for Newsbeuter
# Description: Text based Atom/RSS feed reader
# This file is overwritten after every install/update
# Persistent local customizations
include newsbeuter.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore include newsboat.local
ignore mkdir ${HOME}/.config/newsboat
ignore mkdir ${HOME}/.local/share/newsboat
ignore mkdir ${HOME}/.newsboat
ignore private-bin newsboat

blacklist ${HOME}/.config/newsboat
blacklist ${HOME}/.local/share/newsboat
blacklist ${HOME}/.newsboat

nowhitelist ${HOME}/.config/newsboat
nowhitelist ${HOME}/.local/share/newsboat
nowhitelist ${HOME}/.newsboat

mkdir ${HOME}/.config/newsbeuter
mkdir ${HOME}/.local/share/newsbeuter
mkdir ${HOME}/.newsbeuter

private-bin newsbeuter

# Redirect
include newsboat.profile
