# Firejail profile for ani-cli
# Description: Shell script to watch Anime from the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ani-cli.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/ani-cli
noblacklist ${HOME}/.local/state/ani-cli
noblacklist ${PATH}/patch

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-proc.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/ani-cli
mkdir ${HOME}/.local/state/ani-cli
whitelist ${HOME}/.cache/ani-cli
whitelist ${HOME}/.local/state/ani-cli
include whitelist-run-common.inc
include whitelist-runuser-common.inc

#machine-id
nodvd
noprinters
notv

disable-mnt
private-bin ani-cli,aria2c,cat,cp,curl,cut,ffmpeg,fzf,grep,head,mkdir,mktemp,mv,nl,nohup,patch,printf,rm,rofi,sed,sh,sort,tail,tput,tr,uname,wc
#private-cache
private-etc X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

# Redirect
include mpv.profile
