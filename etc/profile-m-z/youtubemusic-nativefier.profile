# Firejail profile for youtubemusic-nativefier
# Description: Unofficial electron based desktop warpper for YouTube Music
# This file is overwritten after every install/update
# Persistent local customizations
include youtube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/youtubemusic-nativefier-040164

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-shell.inc 
include disable-xdg.inc

mkdir ${HOME}/.config/youtubemusic-nativefier-040164
whitelist ${HOME}/.config/youtubemusic-nativefier-040164
include whitelist-runuser-common.inc 
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

nou2f
novideo
shell none

disable-mnt
private-bin youtubemusic-nativefier
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ati,bumblebee,ca-certificates,crypto-policies,drirc,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,mime.types,nsswitch.conf,nvidia,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-opt youtubemusic-nativefier
private-tmp

# Redirect
include electron.profile
