# Firejail profile for clawsker
# Description: An applet to edit Claws Mail's hidden preferences
# This file is overwritten after every install/update
# Persistent local customizations
include clawsker.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.claws-mail

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.claws-mail
whitelist ${HOME}/.claws-mail
include whitelist-common.inc

apparmor
caps.drop all
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

disable-mnt
private-bin bash,clawsker,perl,sh,which
private-cache
private-dev
private-etc alternatives,fonts
private-lib girepository-1.*,libdbus-glib-1.so.*,libetpan.so.*,libgirepository-1.*,libgtk-x11-2.0.so.*,libstartup-notification-1.so.*,perl*
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
