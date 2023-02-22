# Firejail profile for exiftool
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include exiftool.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /usr/share/perl-image-exiftool
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog
x11 none

# To support exiftool in private-bin on Arch Linux (and derivatives), symlink /usr/bin/vendor_perl/exiftool
# to /usr/bin/exiftool and add the below to your exiftool.local.
# Non-Arch Linux users can safely add the below to their exiftool.local for extra hardening.
#private-bin exiftool,perl
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
