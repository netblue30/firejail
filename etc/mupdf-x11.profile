# Firejail profile for mupdf-x11
# Description: Lightweight PDF viewer
# This file is overwritten after every install/update
# Persistent local customizations
include mupdf-x11.local
# Persistent global definitions
# added by included profile
#include globals.local

memory-deny-write-execute
read-only ${HOME}

# Redirect
include mupdf.profile
