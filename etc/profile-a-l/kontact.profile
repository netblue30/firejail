# Firejail profile for kontact
# Description: Personal information manager
# This file is overwritten after every install/update
# Persistent local customizations
include kontact.local
# Persistent global definitions
# added by included profile
#include globals.local

# Note: kmail/kontact have problems launching akonadi on Debian and Ubuntu.
# One solution is to have akonadi already running when kmail is started.

noblacklist ${HOME}/.cache/kontact
noblacklist ${HOME}/.config/kontact_summaryrc
noblacklist ${HOME}/.config/kontactrc
noblacklist ${HOME}/.local/share/kontact

# Redirect
include kmail.profile
