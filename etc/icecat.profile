# Firejail profile for icecat
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/icecat.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla

mkdir ${HOME}/.cache/mozilla/icecat
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/icecat
whitelist ${HOME}/.mozilla

# private-etc icecat,ca-certificates,ssl,machine-id,dconf,selinux,passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,firefox,mime.types,mailcap,asound.conf,pulse,pki,crypto-policies

# Redirect
include /etc/firejail/firefox-common.profile
