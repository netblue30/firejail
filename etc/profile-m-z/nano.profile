# Firejail profile for nano
# Description: nano is an easy text editor for the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include nano.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.nanorc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /usr/share/nano
include whitelist-usr-share-common.inc

# Add the next lines to your nano.local if you want to edit files in /etc directly.
#ignore private-etc
#writable-etc
# Add the next line to your nano.local if you want to edit files in /var directly.
#writable-var

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
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog
x11 none

#disable-mnt
private-bin nano,rnano
private-cache
private-dev
private-etc nanorc

dbus-user none
dbus-system none

memory-deny-write-execute
read-write ${HOME}/.config/nano
read-write ${HOME}/.nanorc
restrict-namespaces
