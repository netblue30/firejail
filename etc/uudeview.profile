# Firejail profile for uudeview
# Description: Smart multi-file multi-part decoder
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/uudeview.local
# Persistent global definitions
# added by included default.profile
#include /etc/firejail/globals.local

hostname uudeview
ignore noroot
net none
nodbus
nodvd
nosound
notv
novideo
shell none
tracelog

private-bin uudeview
private-cache
private-dev
private-etc ld.so.preload

include /etc/firejail/default.profile
