# Firejail profile for secret-tool
# Description: Library for storing and retrieving passwords and other secrets
# This file is overwritten after every install/update
# Persistent local customizations
include secret-tool.local
# Persistent global definitions
# added by included profile
#include globals.local

# Redirect
include gnome-keyring.profile
