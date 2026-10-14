# Firejail profile for ChiPass-cli
# Description: command line interface for ChiPass
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ChiPass-cli.local
# Persistent global definitions
# added by included profile
#include globals.local

# Redirect
include ChiPass.profile
