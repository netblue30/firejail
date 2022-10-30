# Firejail profile for freetube
# Description: Youtube client with local subscription feature
# This file is overwritten after every install/update
# Persistent local customizations
include freetube.local
# Persistent global definitions
include globals.local

ignore dbus-user none

noblacklist ${HOME}/.config/FreeTube

include allow-bin-sh.inc

include disable-shell.inc

mkdir ${HOME}/.config/FreeTube
whitelist ${HOME}/.config/FreeTube

private-bin electron,electron[0-9],electron[0-9][0-9],freetube,sh
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,mime.types,nsswitch.conf,pki,pulse,resolv.conf,ssl,X11,xdg

dbus-user filter
dbus-user.own org.mpris.MediaPlayer2.chromium.*
dbus-user.own org.mpris.MediaPlayer2.freetube

# Redirect
include electron.profile
