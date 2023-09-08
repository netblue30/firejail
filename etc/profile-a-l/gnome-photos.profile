# Firejail profile for gnome-photos
# Description: Access, organize and share your photos with GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-photos.local
# Persistent global definitions
include globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.local/share/gnome-photos

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
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
seccomp.block-secondary
tracelog

#private-bin gjs,gnome-photos
private-dev
private-tmp

restrict-namespaces
