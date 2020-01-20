# Firejail profile for claws-mail
# Description: Fast, lightweight and user-friendly GTK+2 based email client
# This file is overwritten after every install/update
# Persistent local customizations
include claws-mail.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.claws-mail

mkdir ${HOME}/.claws-mail
whitelist ${HOME}/.claws-mail

# If you use python-based plugins you need to uncomment the below (or put them in your claws-mail.local)
# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
#include allow-python3.inc

whitelist /usr/share/doc/claws-mail

# Redirect
include email-common.profile
