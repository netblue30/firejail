# Firejail profile for uudeview
# Description: Smart multi-file multi-part decoder
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include uudeview.local
# Persistent global definitions
# added by included default.profile
#include globals.local

hostname uudeview
ignore noroot
net none
nodbus
nodvd
nosound
notv
nou2f
novideo
shell none
tracelog

private-bin uudeview
private-cache
private-dev
private-etc alternatives,ld.so.preload

include default.profile
