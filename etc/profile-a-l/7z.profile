# Firejail profile for 7z
# Description: File archiver with high compression ratio
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include 7z.local
# Persistent global definitions
include globals.local

ignore include disable-shell.inc
ignore nogroups
include archiver-common.inc

#private-bin 7z,7z*,p7zip
