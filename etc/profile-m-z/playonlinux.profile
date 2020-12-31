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

include allow-python2.inc
include allow-python3.inc
include allow-perl.inc

# Redirect
include wine.profile
