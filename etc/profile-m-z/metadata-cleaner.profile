# Firejail profile for metadata-cleaner
# Description: Python GTK application to view and clean metadata in files, using mat2
# This file is overwritten after every install/update
# Persistent local customizations
include metadata-cleaner.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python3 (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

whitelist /usr/share/metadata-remover
whitelist /usr/share/perl-image-exiftool
include whitelist-run-common.inc
include whitelist-runuser-common.inc
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
noprinters
noroot
notv
nou2f
novideo
nosound
protocol unix,netlink
seccomp
seccomp.block-secondary
tracelog

#disable-mnt
private-bin bash,exiftool,ffmpeg,metadata-cleaner,perl,python,python*,sh,which
private-cache
private-dev
private-etc @x11,mime.types
private-tmp

dbus-user filter
dbus-user.own fr.romainvigier.MetadataCleaner
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gtk.vfs.UDisks2VolumeMonitor
dbus-system none

restrict-namespaces
