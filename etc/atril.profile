# Firejail profile for atril
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/atril.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/atril
noblacklist ${HOME}/.config/atril

#noblacklist ${HOME}/.local/share
# it seems to use only ${HOME}/.local/share/webkitgtk

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

# apparmor
caps.drop all
machine-id
no3d
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

private-bin atril, atril-previewer, atril-thumbnailer
private-dev
private-etc fonts,ld.so.cache
# atril uses webkit gtk to display epub files
# waiting for globbing support in private-lib; for now hardcoding it to webkit2gtk-4.0
#private-lib webkit2gtk-4.0 - problems on Arch with the new version of WebKit
private-tmp

# webkit gtk killed by memory-deny-write-execute
#memory-deny-write-execute
noexec ${HOME}
noexec /tmp
