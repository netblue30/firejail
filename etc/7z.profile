quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/7z.local

# 7zip crompression tool profile
ignore noroot

include /etc/firejail/default.profile

blacklist /tmp/.X11-unix

tracelog
net none
nosound
novideo
shell none
private-dev
nosound
no3d
