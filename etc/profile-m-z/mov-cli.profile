# Firejail profile for mov-cli
# Description: Python script for watching movies and TV shows via the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mov-cli.local
# Persistent global definitions
# added by included profile
#include globals.local

include disable-proc.inc
include disable-xdg.inc

include whitelist-run-common.inc
include whitelist-runuser-common.inc

#machine-id
nodvd
noprinters
notv

disable-mnt
private-bin ffmpeg,fzf,mov-cli
#private-cache
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,group,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,magic,magic.mgc,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,X11,xdg
private-tmp

# Redirect
include mpv.profile
