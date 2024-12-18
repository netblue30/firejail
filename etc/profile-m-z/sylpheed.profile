# Firejail profile for sylpheed
# Description: Lightweight e-mail client made with GTK
# This file is overwritten after every install/update
# Persistent local customizations
include sylpheed.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.sylpheed-2.0

mkdir ${HOME}/.sylpheed-2.0
whitelist ${HOME}/.sylpheed-2.0

whitelist /usr/share/sylpheed

#private-bin curl,gpg,gpg2,gpg-agent,gpgsm,pinentry,pinentry-gtk-2,sylpheed

# Redirect
include email-common.profile
