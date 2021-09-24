# Firejail profile for unrar
# Description: Unarchiver for .rar files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include unrar.local
# Persistent global definitions
include globals.local

private-bin unrar
private-etc alternatives,group,ld.so.preload,localtime,passwd
private-tmp

# Redirect
include archiver-common.profile
