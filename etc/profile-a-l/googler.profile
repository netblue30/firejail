# Firejail profile for googler
# Description: Search Google from your terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include googler.local
# Persistent global definitions
include globals.local

private-bin googler

# Redirect
include googler-common.profile
