# Firejail profile for exiftool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include exiftool.local
# Persistent global definitions
include globals.local

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/perl5
include whitelist-usr-share-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
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
x11 none

# To support exiftool in private-bin on Arch Linux (and derivatives), symlink /usr/bin/vendor_perl/exiftool to /usr/bin/exiftool and uncomment the below.
# Users on non-Arch Linux distributions can safely uncomment (or put in exiftool.local) the line below to enable extra hardening.
#private-bin exiftool,perl
private-cache
private-dev
private-etc alternatives
private-tmp

memory-deny-write-execute
