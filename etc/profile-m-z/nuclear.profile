# Firejail profile for nuclear
# Description: Stream music from Youtube,Soundcloud,Jamendo
# This file is overwritten after every install/update
# Persistent local customizations
include nuclear.local
# Persistent global definitions
include globals.local

ignore dbus-user

noblacklist ${HOME}/.config/nuclear

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-shell.inc 
include disable-xdg.inc

mkdir ${HOME}/.config/nuclear
whitelist ${HOME}/.config/nuclear
include whitelist-runuser-common.inc 
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

no3d
nou2f
novideo
shell none

disable-mnt
# private-bin nuclear
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,mime.types,nsswitch.conf,pki,pulse,resolv.conf,selinux,ssl,X11,xdg
private-opt nuclear
private-tmp

# Redirect
include electron.profile
