# Firejail profile for claws-mail
# Description: Fast, lightweight and user-friendly GTK-based email client
# This file is overwritten after every install/update
# Persistent local customizations
include claws-mail.local
# Persistent global definitions
include globals.local

# Note: If you use things like claws-mail's "fancy" (html rendering) plugin and
# the X11 window freezes, 'no3d' is likely the cause.  In which case, try
# adding the following line to claws-mail.local:
#ignore no3d

noblacklist ${HOME}/.cache/claws-mail
noblacklist ${HOME}/.claws-mail

mkdir ${HOME}/.cache/claws-mail
mkdir ${HOME}/.claws-mail
whitelist ${HOME}/.cache/claws-mail
whitelist ${HOME}/.claws-mail

# Add the below lines to your claws-mail.local if you use python-based plugins.
# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
#include allow-python3.inc

whitelist /usr/share/doc/claws-mail

#private-bin claws-mail,curl,gpg,gpg2,gpg-agent,gpgsm,gpgme-config,pinentry,pinentry-gtk-2

# Redirect
include email-common.profile
