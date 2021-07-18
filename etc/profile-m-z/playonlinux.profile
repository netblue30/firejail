# Firejail profile for playonlinux
# Description: Front-end for Wine
# This file is overwritten after every install/update
# Persistent local customizations
include playonlinux.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.PlayOnLinux

# nc is needed to run playonlinux
noblacklist ${PATH}/nc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# Redirect
include wine.profile
