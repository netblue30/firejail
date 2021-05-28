# Firejail profile for gunzip
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gunzip.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore include disable-shell.inc

# Redirect
include gzip.profile
