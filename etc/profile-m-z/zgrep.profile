# Firejail profile for zgrep
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include zgrep.local
# Persistent global definitions
# added by included profile
#include globals.local

# Allow running kernel config check
ignore include disable-shell.inc
noblacklist /proc/config.gz

# Redirect
include gzip.profile
