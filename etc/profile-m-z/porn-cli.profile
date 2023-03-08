# Firejail profile for porn-cli
# Description: Python script for watching porn via the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include porn-cli.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin porn-cli

# Redirect
include mov-cli.profile
