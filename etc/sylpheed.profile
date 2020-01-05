# Firejail profile for sylpheed
# Description: Light weight e-mail client with GTK+
# This file is overwritten after every install/update
# Persistent local customizations
include sylpheed.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.sylpheed-2.0
noblacklist ${HOME}/Mail

blacklist ${HOME}/.claws-mail

nowhitelist /usr/share/doc/claws-mail
whitelist /usr/share/sylpheed

# Redirect
include claws-mail.profile
