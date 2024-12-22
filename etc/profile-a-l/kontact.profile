# Firejail profile for kontact
# Description: Personal information manager
# This file is overwritten after every install/update
# Persistent local customizations
include kontact.local
# Persistent global definitions
# added by included profile
#include globals.local

# kmail/kontact has problems launching akonadi in debian and ubuntu.
# one solution is to have akonadi already running when kmail is started

noblacklist ${HOME}/.cache/kontact
noblacklist ${HOME}/.config/kontact_summaryrc
noblacklist ${HOME}/.config/kontactrc
noblacklist ${HOME}/.local/share/kontact

# restrict-namespaces

# Redirect
include kmail.profile
