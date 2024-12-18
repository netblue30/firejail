# Firejail profile for lobster
# Description: Shell script to watch Movies/Webseries/Shows from the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include lobster.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore private-dev
ignore read-only ${HOME}/.local/share/applications

noblacklist ${HOME}/.cache/ueberzugpp
noblacklist ${HOME}/.config/lobster
noblacklist ${HOME}/.config/ueberzugpp
noblacklist ${HOME}/.local/share/applications/lobster
noblacklist ${HOME}/.local/share/lobster
noblacklist ${PATH}/openssl
noblacklist ${PATH}/patch

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-proc.inc
include disable-xdg.inc

mkdir ${HOME}/.config/lobster
mkdir ${HOME}/.local/share/lobster
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/ueberzugpp
whitelist ${HOME}/.config/lobster
whitelist ${HOME}/.config/ueberzugpp
whitelist ${HOME}/.local/share/applications/lobster
whitelist ${HOME}/.local/share/lobster
include whitelist-run-common.inc
include whitelist-runuser-common.inc

#machine-id
nodvd
noprinters
notv

disable-mnt
private-bin base64,basename,bash,cat,curl,cut,date,dirname,echo,ffmpeg,ffprobe,find,fzf,grep,head,hxunent,ln,lobster,ls,mkdir,mkfifo,nano,nohup,openssl,patch,pgrep,ps,rm,rofi,sed,sh,sleep,socat,tail,tee,tput,tr,ueberzugpp,uname,uuidgen,vim,wc
#private-cache
private-etc X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

# Redirect
include mpv.profile
