# Firejail profile for lobster
# Description: Shell script to watch Movies/Webseries/Shows from the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include lobster.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/lobster
noblacklist ${HOME}/.local/share/lobster

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-proc.inc
include disable-xdg.inc

mkdir ${HOME}/.config/lobster
mkdir ${HOME}/.local/share/lobster
whitelist ${HOME}/.config/lobster
whitelist ${HOME}/.local/share/lobster
include whitelist-run-common.inc
include whitelist-runuser-common.inc

#machine-id
nodvd
noprinters
notv

disable-mnt
private-bin curl,cut,fzf,grep,head,lobster,mv,patch,rm,sed,sh,tail,tput,tr,uname
#private-cache
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,pki,protocols,pulse,resolv.conf,rpc,services,ssl,X11,xdg
private-tmp

# Redirect
include mpv.profile
