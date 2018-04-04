# Firejail profile for knotes
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/knotes.local
# Persistent global definitions
include /etc/firejail/globals.local

# knotes has problems launching akonadi in debian and ubuntu.
# one solution is to have akonadi already running when knotes is started

noblacklist ${HOME}/.config/knotesrc
noblacklist ${HOME}/.local/share/knotes


# Redirect
include /etc/firejail/kmail.profile
