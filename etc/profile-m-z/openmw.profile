# Firejail profile for openmw
# Description: Open source engine re-implementation for Morrowind
# This file is overwritten after every install/update
# Persistent local customizations
include openmw.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/openmw
noblacklist ${HOME}/.local/share/openmw

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.config/openmw
mkdir ${HOME}/.local/share/openmw
whitelist ${HOME}/.config/openmw
# Copy Morrowind data files into ${HOME}/.local/share/openmw or load them from /mnt.
# Alternatively you can whitelist custom paths in your openmw.local.
whitelist ${HOME}/.local/share/openmw
whitelist /usr/share/openmw
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
netfilter
# Add 'ignore nodvd' to your openmw.local when installing from disc.
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
seccomp.block-secondary
tracelog

private-bin bsatool,esmtool,niftest,openmw,openmw-cs,openmw-essimporter,openmw-iniimporter,openmw-launcher,openmw-wizard
private-cache
private-dev
private-etc @x11,bumblebee,glvnd,mime.types,openmw
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
