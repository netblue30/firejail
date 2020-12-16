# Firejail profile for tar
# Description: GNU version of the tar archiving utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tar.local
# Persistent global definitions
include globals.local

# Arch Linux (based distributions) need access to /var/lib/pacman. As we drop all capabilities this is automatically read-only.
noblacklist /var/lib/pacman

ignore include disable-shell.inc
include archiver-common.inc

# support compressed archives
private-bin awk,bash,bzip2,compress,firejail,grep,gtar,gzip,lbzip2,lzip,lzma,lzop,sh,tar,xz
private-etc alternatives,group,localtime,login.defs,passwd
private-lib libfakeroot,liblzma.so.*,libreadline.so.*
# Debian based distributions need this for 'dpkg --unpack' (incl. synaptic)
writable-var
