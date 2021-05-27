# Firejail profile for gnome-font-viewer
# Description: Font viewer for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-font-viewer.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodvd
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-dev
private-tmp

