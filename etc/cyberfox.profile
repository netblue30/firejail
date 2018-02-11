# Firejail profile for cyberfox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cyberfox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.8pecxstudios
noblacklist ${HOME}/.cache/8pecxstudios

mkdir ${HOME}/.8pecxstudios
mkdir ${HOME}/.cache/8pecxstudios
whitelist ${HOME}/.8pecxstudios
whitelist ${HOME}/.cache/8pecxstudios

# private-bin cyberfox,which,sh,dbus-launch,dbus-send,env
# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,cyberfox,mime.types,mailcap,asound.conf,pulse

# Redirect
include /etc/firejail/firefox-common.profile
