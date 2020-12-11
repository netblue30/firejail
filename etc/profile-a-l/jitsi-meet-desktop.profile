# Firejail profile for jitsi-meet-desktop
# Description: Jitsi Meet desktop application powered by Electron
# This file is overwritten after every install/update
# Persistent local customizations
include jitsi-meet-desktop.local
# Persistent global definitions
include globals.local

# See ABC.XYZ.ADD.A.NOTE
ignore nou2f
ignore novideo
ignore shell none

ignore noexec /tmp

noblacklist ${HOME}/.config/Jitsi Meet

nowhitelist ${DOWNLOADS}

mkdir ${HOME}/.config/Jitsi Meet
whitelist ${HOME}/.config/Jitsi Meet

private-bin bash,jitsi-meet-desktop
private-etc alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,drirc,fonts,glvnd,group,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,nvidia,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,X11,xdg

# Redirect
include electron.profile
