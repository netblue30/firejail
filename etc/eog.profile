# Firejail profile for eog
# Description: Eye of GNOME graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eog.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.config/eog
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,netlink
seccomp
shell none
tracelog

# private-bin, private-etc and private-lib break 'Open With' / 'Open in file manager'
# comment those if you need that functionality
# or put 'ignore private-bin', 'ignore private-etc' and 'ignore private-lib' in your eog.local
private-bin eog
private-cache
private-dev
private-etc alternatives,fonts,gtk-3.0,dconf
private-lib eog,gdk-pixbuf-2.*,gio,girepository-1.*,gvfs,libgconf-2.so.*
private-tmp

# memory-deny-write-execute
