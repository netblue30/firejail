# Firejail profile alias for blink-common-hardened.inc
# This file is overwritten after every install/update
# Persistent local customizations
include chromium-common-hardened.inc.local
# Persistent global definitions
# added by caller profile
#include globals.local

# Redirect
include blink-common-hardened.inc.profile
