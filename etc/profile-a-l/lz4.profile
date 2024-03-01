# Firejail profile for lz4
# Description: Compress or decompress .lz4 files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include lz4.local
# Persistent global definitions
include globals.local

# Redirect
include archiver-common.profile
