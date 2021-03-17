# Firejail profile for PCSX2
# Description: A PlayStation 2 emulator
# This file is overwritten after every install/update
# Persistent local customizations
include PCSX2.local
# Persistent global definitions
include globals.local

# Note: you must whitelist your games folder in a PCSX2.local

noblacklist ${HOME}/.config/PCSX2

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.config/PCSX2
whitelist ${HOME}/.config/PCSX2
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
netfilter
# Uncomment the following line if not loading games from disc
#nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,netlink
#seccomp - breaks loading with no logs
shell none
#tracelog - 32/64 bit incompatibility

private-bin PCSX2
private-cache
# uncomment the following line if you do not need controller support
#private-dev
private-etc alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,nvidia,pango,pki,protocols,pulse,resolv.conf,rpc,services,ssl,X11,xdg
private-opt none
private-tmp

dbus-user none
dbus-system none
