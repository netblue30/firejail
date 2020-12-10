# Firejail profile for youtube
# Description: Unofficial electron based desktop warpper for YouTube
# This file is overwritten after every install/update
# Persistent local customizations
include youtube.local
# Persistent global definitions
include globals.local

# See ABC.XYZ.ADD.A.NOTE
ignore nou2f

noblacklist ${HOME}/.config/Youtube

include disable-shell.inc 

mkdir ${HOME}/.config/Youtube
whitelist ${HOME}/.config/Youtube
include whitelist-runuser-common.inc 
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

disable-mnt
private-bin youtube
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ati,bumblebee,ca-certificates,crypto-policies,drirc,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,mime.types,nsswitch.conf,nvidia,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-opt Youtube
private-tmp

# Redirect
include electron.profile
