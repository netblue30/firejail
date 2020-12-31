# Firejail profile for zgrep
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include zgrep.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow running kernel config check
noblacklist ${PATH}/bash
noblacklist ${PATH}/sh
noblacklist /proc/config.gz

# Redirect
include gzip.profile
