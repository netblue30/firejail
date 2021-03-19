# Firejail profile for Beyond Compare by Scooter Software
# Description: directory and file compare utility
# Disables the network, which only impacts checking for updates.
# This file is overwritten after every install/update
# Persistent local customizations
include bcompare.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/bcompare
# In case the user decides to include disable-programs.inc, still allow
# KDE's Gwenview to view images via right click -> Open With -> Associated Application
noblacklist ${HOME}/.config/gwenviewrc

# Uncomment the next line (or put it into your bcompare.local) if you don't need to compare files in disable-common.inc
#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# Uncomment the next line (or put it into your bcompare.local) if you don't need to compare files in disable-programs.inc
#include disable-programs.inc
# Uncommenting this breaks launch
# include disable-shell.inc
include disable-write-mnt.inc
# Don't disable ${DOCUMENTS}, ${MUSIC}, ${PICTURES}, ${VIDEOS}
# include disable-xdg.inc

# include whitelist-common.inc
# include whitelist-runuser-common.inc
# include whitelist-usr-share-common.inc
# include whitelist-var-common.inc

apparmor
caps.drop all
# Uncommenting might break Pulse Audio
#machine-id
net none
no3d
nodvd
nogroups
nonewprivs
noroot
# Allow applications launched on sound files to play them
#nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-cache
private-dev
# see /usr/share/doc/firejail/profile.template for more common private-etc paths.
# private-etc alternatives,fonts,machine-id
# Necessary because of the `include disable-exec.inc` line. Prevents error "Error fstat: fs.c:504 fs_remount_simple: Transport endpoint is not connected ... cannot sync with peer: unexpected EOF Peer [...] unexpectedly exited with status 1"
private-tmp

dbus-user none
dbus-system none
