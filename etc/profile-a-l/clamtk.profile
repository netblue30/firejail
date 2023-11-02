# Firejail profile for clamtk
# Description: Easy to use, light-weight, on-demand virus scanner for Linux systems
# This file is overwritten after every install/update
# Persistent local customizations
include clamtk.local
# Persistent global definitions
include globals.local

include disable-exec.inc

# Add the below lines to your clamtk.local if you update signatures databases per-user:
#ignore net none
#netfilter
#protocol inet,inet6

caps.drop all
ipc-namespace
net none
no3d
nodvd
# nogroups breaks scanning
#nogroups
noinput
nonewprivs
# noroot breaks scanning
#noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp

private-dev

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gtk.vfs.UDisks2VolumeMonitor
dbus-system none

restrict-namespaces
