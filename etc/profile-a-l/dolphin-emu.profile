# Firejail profile for dolphin-emu
# Description: An emulator for Gamecube and Wii games
# This file is overwritten after every install/update
# Persistent local customizations
include dolphin-emu.local
# Persistent global definitions
include globals.local

# Note: you must whitelist your games folder in your dolphin-emu.local.

noblacklist ${HOME}/.cache/dolphin-emu
noblacklist ${HOME}/.config/dolphin-emu
noblacklist ${HOME}/.local/share/dolphin-emu

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-write-mnt.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/dolphin-emu
mkdir ${HOME}/.config/dolphin-emu
mkdir ${HOME}/.local/share/dolphin-emu
whitelist ${HOME}/.cache/dolphin-emu
whitelist ${HOME}/.config/dolphin-emu
whitelist ${HOME}/.local/share/dolphin-emu
whitelist /usr/share/dolphin-emu
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
# Add the next line to your dolphin-emu.local if you do not need NetPlay support.
# net none
netfilter
# Add the next line to your dolphin-emu.local if you do not need disc support.
#nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink,bluetooth
seccomp
tracelog

private-bin bash,dolphin-emu,dolphin-emu-x11,sh
private-cache
# Add the next line to your dolphin-emu.local if you do not need controller support.
#private-dev
private-etc alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,kde4rc,kde5rc,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,nvidia,pango,pki,protocols,pulse,resolv.conf,rpc,services,ssl,Trolltech.conf,X11,xdg
private-opt none
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
