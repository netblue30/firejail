# Firejail profile for youtubemusic-nativefier
# Description: Unofficial electron based desktop warpper for YouTube Music
# This file is overwritten after every install/update
# Persistent local customizations
include youtube.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/youtubemusic-nativefier-040164

include disable-shell.inc

mkdir ${HOME}/.config/youtubemusic-nativefier-040164
allow  ${HOME}/.config/youtubemusic-nativefier-040164

private-bin youtubemusic-nativefier
private-etc alsa,alternatives,asound.conf,ati,bumblebee,ca-certificates,crypto-policies,drirc,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,mime.types,nsswitch.conf,nvidia,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-opt youtubemusic-nativefier

# Redirect
include electron.profile
