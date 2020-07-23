# Firejail profile for freetube
# Description: Youtube client with local subscription feature
# This file is overwritten after every install/update
# Persistent local customizations
include freetube.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/FreeTube

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-shell.inc 
include disable-xdg.inc

mkdir ${HOME}/.config/FreeTube
whitelist ${HOME}/.config/FreeTube

shell none
seccomp !chroot

disable-mnt
private-bin freetube
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,mime.types,nsswitch.conf,pki,pulse,resolv.conf,ssl,xdg,X11
private-tmp

# Redirect
include electron.profile