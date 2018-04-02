# Firejail profile for gnome-calculator
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/gnome-calculator.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
# net none
netfilter
no3d
# nodbus - makes settings immutable
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin gnome-calculator
private-dev
private-lib gdk-pixbuf-2.0,gio,girepository-1.0,gvfs,libgconf-2.so.4,libgnutls.so.30,libproxy.so.1,librsvg-2.so.2,libxml2.so.2
private-tmp

#memory-deny-write-execute  - breaks on Arch
noexec ${HOME}
noexec /tmp
