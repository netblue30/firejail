# Firejail profile for zstd
# Description: Zstandard - Fast real-time compression algorithm
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include zstd.local
# Persistent global definitions
include globals.local

ignore include disable-shell.inc
include archiver-common.inc
