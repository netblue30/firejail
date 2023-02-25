# Firejail profile alias for chrome-common-hardened.inc
# This file is overwritten after every install/update
# Persistent local customizations
include electron-hardened.inc.local
# Persistent global definitions
# added by caller profile
#include globals.local

# Redirect
include chromium-common-hardened.inc.profile
