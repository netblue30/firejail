# Firejail profile for nuclear
# Description: Stream music from Youtube,Soundcloud,Jamendo
# This file is overwritten after every install/update
# Persistent local customizations
include nuclear.local
# Persistent global definitions
include globals.local

ignore dbus-user

noblacklist ${HOME}/.config/nuclear

include disable-shell.inc

mkdir ${HOME}/.config/nuclear
whitelist ${HOME}/.config/nuclear

no3d

# private-bin nuclear
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.preload,mime.types,nsswitch.conf,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-opt nuclear

# Redirect
include electron.profile
