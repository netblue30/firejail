# Firejail profile for ddgr
# Description:  Search DuckDuckGo from your terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ddgr.local
# Persistent global definitions
include globals.local

private-bin ddgr

# Redirect
include googler-common.profile
