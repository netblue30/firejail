# Firejail profile for lzop
# Description: File compressor using lzo lib
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include lzop.local
# Persistent global definitions
# added by included profile
#include globals.local

# Redirect
include cpio.profile
