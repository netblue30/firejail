# Firejail profile for Newsbeuter
# Description: Text based Atom/RSS feed reader
# This file is overwritten after every install/update
# Persistent local customizations
include newsbeuter.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore include newsboat.local
ignore mkdir ${HOME}/.local/share/newsboat
ignore noblacklist ${HOME}/.config/newsboat
ignore noblacklist ${HOME}/.local/share/newsboat
ignore noblacklist ${HOME}/.newsboat
ignore private-bin newsboat
ignore whitelist ${HOME}/.config/newsboat
ignore whitelist ${HOME}/.local/share/newsboat
ignore whitelist ${HOME}/.newsboat

mkdir ${HOME}/.local/share/newsbeuter

private-bin newsbeuter

# Redirect
include newsboat.profile
