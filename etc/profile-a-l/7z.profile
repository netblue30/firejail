# Firejail profile for 7z
# Description: File archiver with high compression ratio
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include 7z.local
# Persistent global definitions
include globals.local

noblacklist ${PATH}/bash
noblacklist ${PATH}/sh
include archiver-common.inc

private-bin 7z,7z*,bash,p7zip,sh
