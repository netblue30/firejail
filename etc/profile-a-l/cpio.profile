# Firejail profile for cpio
# Description: A program to manage archives of files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cpio.local
# Persistent global definitions
include globals.local

nodeny  /sbin
nodeny  /usr/sbin

# Redirect
include archiver-common.profile
