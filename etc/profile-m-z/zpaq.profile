# Firejail profile for zpaq
# Description: Programmable file compressor, library and utilities. Based on the PAQ compression algorithm.
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include zpaq.local
# Persistent global definitions
# added by included profile
#include globals.local

# mdwx breaks 'list' functionality
ignore memory-deny-write-execute

# Redirect
include cpio.profile
