# Firejail profile for ytmdesktop
# Description: Unofficial electron based desktop warpper for YouTube Music
# This file is overwritten after every install/update
# Persistent local customizations
include youtube.local
# Persistent global definitions
include globals.local

ignore dbus-user none

noblacklist ${HOME}/.config/youtube-music-desktop-app

mkdir ${HOME}/.config/youtube-music-desktop-app
whitelist ${HOME}/.config/youtube-music-desktop-app
include whitelist-runuser-common.inc 
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

disable-mnt
# private-bin env,ytmdesktop
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ati,bumblebee,ca-certificates,crypto-policies,drirc,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,mime.types,nsswitch.conf,nvidia,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
# private-opt 
private-tmp

# Redirect
include electron.profile
