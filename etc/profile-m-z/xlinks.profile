# Firejail profile for xlinks
# Description: Text WWW browser (X11)
# This file is overwritten after every install/update
# Persistent local customizations
include xlinks.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist /tmp/.X11-unix

include whitelist-common.inc

# if you want to use user-configured programs add 'private-bin PROGRAM1,PROGRAM2'
# to your xlinks.local or append 'PROGRAM1,PROGRAM2' to this private-bin line
private-bin xlinks
private-etc alternatives,fonts,ld.so.cache,ld.so.preload

# Redirect
include links.profile
