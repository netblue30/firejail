# Firejail profile for tar
# Description: GNU version of the tar archiving utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tar.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

# Arch Linux (based distributions) need access to /var/lib/pacman. As we drop all capabilities this is automatically read-only.
noblacklist /var/lib/pacman

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
hostname tar
ipc-namespace
machine-id
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog
x11 none

# support compressed archives
private-bin awk,bash,bzip2,compress,firejail,grep,gtar,gzip,lbzip2,lzip,lzma,lzop,sh,tar,xz
private-cache
private-dev
private-etc alternatives,group,localtime,login.defs,passwd
private-lib libfakeroot
# Debian based distributions need this for 'dpkg --unpack' (incl. synaptic)
writable-var

memory-deny-write-execute
