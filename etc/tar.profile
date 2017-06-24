quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/tar.local

# tar profile
ignore noroot
include /etc/firejail/default.profile

blacklist /tmp/.X11-unix

hostname tar
net none
no3d
nosound
shell none
tracelog

# support compressed archives
private-bin sh,bash,dash,tar,gtar,compress,gzip,lzma,xz,bzip2,lbzip2,lzip,lzop
private-dev
private-etc passwd,group,localtime
