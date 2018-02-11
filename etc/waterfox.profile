# Firejail profile for waterfox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/waterfox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.cache/waterfox
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.waterfox

mkdir ${HOME}/.cache/mozilla/firefox
mkdir ${HOME}/.mozilla
mkdir ${HOME}/.cache/waterfox
mkdir ${HOME}/.waterfox
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/.cache/waterfox
whitelist ${HOME}/.mozilla
whitelist ${HOME}/.waterfox

# waterfox requires a shell to launch on Arch. We can possibly remove sh though.
# private-bin waterfox,which,sh,dbus-launch,dbus-send,env,bash
# private-etc ca-certificates,ssl,machine-id,dconf,selinux,passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,waterfox,mime.types,mailcap,asound.conf,pulse,pki,crypto-policies

# Redirect
include /etc/firejail/firefox-common.profile
