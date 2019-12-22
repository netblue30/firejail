# Firejail profile for x-terminal-emulator
# This file is overwritten after every install/update
# Persistent local customizations
include x-terminal-emulator.local
# Persistent global definitions
include globals.local

caps.drop all
ipc-namespace
net none
netfilter
nodbus
nogroups
noroot
nou2f
protocol unix
seccomp

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,pulse,xdg

noexec /tmp
