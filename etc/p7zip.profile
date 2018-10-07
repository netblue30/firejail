# Firejail profile for p7zip
# Description: 7zr file archiver with high compression ratio
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/p7zip.local
# Persistent global definitions
# added by included profile
#include /etc/firejail/globals.local

# Redirect
include /etc/firejail/7z.profile
