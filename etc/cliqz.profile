# Firejail profile for cliqz
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cliqz.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/cliqz
noblacklist ${HOME}/.config/cliqz

mkdir ${HOME}/.cache/cliqz
mkdir ${HOME}/.config/cliqz
whitelist ${HOME}/.cache/cliqz
whitelist ${HOME}/.config/cliqz

# private-etc ca-certificates,ssl,machine-id,dconf,selinux,passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,firefox,cliqz,mime.types,mailcap,asound.conf,pulse,pki,crypto-policies

# Redirect
include /etc/firejail/firefox-common.profile
