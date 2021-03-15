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
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.config/openmw
mkdir ${HOME}/.local/share/openmw
whitelist ${HOME}/Downloads/Morrowind
whitelist ${HOME}/.config/openmw
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
# Uncomment the following line if installing from disc
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin bsatool,esmtool,niftest,openmw*
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,bumblebee,drirc,fonts,glvnd,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nvidia,openmw,pango,pulse,Trolltech.conf,X11,xdg
private-opt none
private-tmp

dbus-user none
dbus-system none
