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
deny  ${PATH}/newsboat

deny  ${HOME}/.config/newsboat
deny  ${HOME}/.local/share/newsboat
deny  ${HOME}/.newsboat

noallow  ${HOME}/.config/newsboat
noallow  ${HOME}/.local/share/newsboat
noallow  ${HOME}/.newsboat

mkdir ${HOME}/.config/newsbeuter
mkdir ${HOME}/.local/share/newsbeuter
mkdir ${HOME}/.newsbeuter

private-bin newsbeuter

# Redirect
include newsboat.profile
