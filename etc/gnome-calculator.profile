# Firejail profile for gnome-calculator
# Description: GNOME desktop calculator
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
include /etc/firejail/disable-xdg.inc

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
private-lib gdk-pixbuf-2.*,gio,girepository-1.*,gvfs,libgconf-2.so.*,libgnutls.so.*,libproxy.so.*,librsvg-2.so.*,libxml2.so.*
private-tmp

#memory-deny-write-execute  - breaks on Arch
noexec ${HOME}
noexec /tmp
