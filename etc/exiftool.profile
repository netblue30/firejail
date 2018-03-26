# Firejail profile for exiftool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/exiftool.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

# Allow access to perl
noblacklist ${PATH}/perl
noblacklist /usr/lib/perl*
noblacklist /usr/share/perl*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin exiftool,perl
private-dev
private-etc none
private-tmp
