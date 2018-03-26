# Firejail profile for gnome-font-viewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-font-viewer.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
