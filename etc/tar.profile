# Firejail profile for tar
# Description: GNU version of the tar archiving utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tar.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix

hostname tar
ignore noroot
net none
no3d
nodbus
nodvd
nosound
notv
nou2f
novideo
shell none
tracelog

# support compressed archives
private-bin sh,bash,tar,gtar,compress,gzip,lzma,xz,bzip2,lbzip2,lzip,lzop
private-dev
private-etc alternatives,passwd,group,localtime
private-lib

# Debian based distributions need this for 'dpkg --unpack' (incl. synaptic)
writable-var

include default.profile
