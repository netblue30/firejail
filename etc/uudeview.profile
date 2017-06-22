quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/uudeview.local

# uudeview profile
ignore noroot
include /etc/firejail/default.profile


hostname uudeview
net none
nosound
shell none
tracelog

private-bin uudeview
private-dev
private-etc ld.so.preload
