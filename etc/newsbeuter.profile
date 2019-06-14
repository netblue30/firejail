# Firejail profile for Newsboat
# Description: Text based Atom/RSS feed reader
# This file is overwritten after every install/update
# Persistent local customizations
include newsbeuter.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/newsbeuter
noblacklist ${HOME}/.newsbeuter

mkdir ${HOME}/.config/newsbeuter
mkdir ${HOME}/.newsbeuter
whitelist ${HOME}/.config/newsbeuter
whitelist ${HOME}/.newsbeuter

private-bin newsbeuter

# Redirect
include newsboat.profile
