# Firejail profile for exiftool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include exiftool.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

# Allow access to perl
noblacklist ${PATH}/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin exiftool,perl
private-cache
private-dev
private-etc alternatives
private-tmp
