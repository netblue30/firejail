# Firejail profile for gh
# Description: GitHub's official command-line tool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gh.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/gh

# Redirect
include git.profile
