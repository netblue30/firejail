# Firejail profile for tar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/tar.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

hostname tar
ignore noroot
net none
no3d
nodvd
nosound
notv
novideo
shell none
tracelog

# support compressed archives
private-bin sh,bash,dash,tar,gtar,compress,gzip,lzma,xz,bzip2,lbzip2,lzip,lzop
private-dev
private-etc passwd,group,localtime

include /etc/firejail/default.profile
