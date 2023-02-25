# Firejail profile for fix-qdf
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include fix-qdf.local
# Persistent global definitions
# added by included profile
#include globals.local

private-bin fix-qdf

# Redirect
include qpdf.profile
