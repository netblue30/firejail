# Firejail profile for palemoon
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/palemoon.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/moonchild productions/pale moon
noblacklist ${HOME}/.moonchild productions/pale moon

mkdir ${HOME}/.cache/moonchild productions/pale moon
mkdir ${HOME}/.moonchild productions
whitelist ${HOME}/.cache/moonchild productions/pale moon
whitelist ${HOME}/.moonchild productions

# private-bin palemoon
# private-etc ca-certificates,ssl,machine-id,dconf,selinux,passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,palemoon,mime.types,mailcap,asound.conf,pulse,pki,crypto-policies
# private-opt palemoon

# Redirect
include /etc/firejail/firefox-common.profile
