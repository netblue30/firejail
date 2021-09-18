# Firejail profile for youtube
# Description: Unofficial electron based desktop warpper for YouTube
# This file is overwritten after every install/update
# Persistent local customizations
include youtube.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore nou2f

noblacklist ${HOME}/.config/Youtube

include disable-shell.inc

mkdir ${HOME}/.config/Youtube
whitelist ${HOME}/.config/Youtube

private-bin electron,electron[0-9],electron[0-9][0-9],youtube
private-etc alsa,alternatives,asound.conf,ati,bumblebee,ca-certificates,crypto-policies,drirc,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.preload,mime.types,nsswitch.conf,nvidia,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-opt Youtube

# Redirect
include electron.profile
