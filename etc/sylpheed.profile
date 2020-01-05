# Firejail profile for sylpheed
# Description: Light weight e-mail client with GTK+
# This file is overwritten after every install/update
# Persistent local customizations
include sylpheed.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.sylpheed-2.0
# when storing mail outside the default ${HOME}/Mail path, 'noblacklist' the custom path in your sylpheed.local
# and 'blacklist' it in your disable-common.local too so it is  kept hidden from other applications

blacklist ${HOME}/.claws-mail

nowhitelist /usr/share/doc/claws-mail
whitelist /usr/share/sylpheed

# Redirect
include claws-mail.profile
