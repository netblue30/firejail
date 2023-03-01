# Firejail profile alias for chromium-common-hardened.inc
# This file is overwritten after every install/update
# Persistent local customizations
include electron-common-hardened.inc.local
# Persistent global definitions
# added by caller profile
#include globals.local

# Redirect
include chromium-common-hardened.inc.profile
