# Firejail profile for openbox
# Description: Standards-compliant, fast, light-weight and extensible window manager
# This file is overwritten after every install/update
# Persistent local customizations
include openbox.local
# Persistent global definitions
include globals.local

# all applications started in OpenBox will run in this profile
noblacklist ${HOME}/.config/openbox
include disable-common.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,menu-methods,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
read-only ${HOME}/.config/openbox/autostart
read-only ${HOME}/.config/openbox/environment
