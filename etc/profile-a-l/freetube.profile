# Firejail profile for freetube
# Description: Youtube client with local subscription feature
# This file is overwritten after every install/update
# Persistent local customizations
include freetube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/FreeTube

include disable-shell.inc

mkdir ${HOME}/.config/FreeTube
whitelist ${HOME}/.config/FreeTube

private-bin electron,electron[0-9],electron[0-9][0-9],freetube
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,mime.types,nsswitch.conf,pki,pulse,resolv.conf,ssl,X11,xdg

# Redirect
include electron.profile
