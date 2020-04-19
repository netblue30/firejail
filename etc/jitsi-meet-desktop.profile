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
private-bin bash,jitsi-meet-desktop
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,drirc,fonts,glvnd,group,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,nvidia,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,X11,xdg
private-tmp

# Redirect
include electron.profile
