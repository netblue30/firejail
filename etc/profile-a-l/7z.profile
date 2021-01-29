# Firejail profile for 7z
# Description: File archiver with high compression ratio
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include 7z.local
# Persistent global definitions
include globals.local

# Included in archiver-common.inc
ignore include disable-shell.inc

# Redirect
include archiver-common.inc
