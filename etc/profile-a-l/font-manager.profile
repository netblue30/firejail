# Firejail profile for font-manager
# Description: A simple font management application for GTK desktop environments
# This file is overwritten after every install/update
# Persistent local customizations
include font-manager.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/font-manager
noblacklist ${HOME}/.config/font-manager

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/font-manager
mkdir ${HOME}/.config/font-manager
whitelist ${HOME}/.cache/font-manager
whitelist ${HOME}/.config/font-manager
whitelist /usr/share/font-manager
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
#net none # issues on older versions
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

disable-mnt
private-bin font-manager,python*,yelp
private-dev
private-tmp

#memory-deny-write-execute # breaks on Arch (see issue #1803)
restrict-namespaces
