# Firejail profile for zlib-flate
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include zlib-flate.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin zlib-flate

# Redirect
include qpdf.profile
