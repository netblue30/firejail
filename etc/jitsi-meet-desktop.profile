# Firejail profile for jitsi-meet-desktop
# Description: Jitsi Meet desktop application powered by Electron
# This file is overwritten after every install/update
# Persistent local customizations
include jitsi-meet-desktop.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

noblacklist ${HOME}/.config/Jitsi Meet

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Jitsi Meet
whitelist ${HOME}/.config/Jitsi Meet
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

nowhitelist ${DOWNLOADS}
seccomp !chroot

disable-mnt
private-bin jitsi-meet-desktop,bash
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,xdg,passwd,group,ca-certificates,ssl,pki,crypto-policies,nsswitch.conf,resolv.conf,hosts,host.conf,hostname,protocols,services,rpc,alsa,asound.conf,pulse,machine-id,fonts,pango,X11,drirc,glvnd,bumblebee,nvidia
private-tmp

# Redirect
include electron.profile
