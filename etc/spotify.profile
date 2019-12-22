# Firejail profile for spotify
# This file is overwritten after every install/update
# Persistent local customizations
include spotify.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/spotify
noblacklist ${HOME}/.config/spotify
noblacklist ${HOME}/.local/share/spotify

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/spotify
mkdir ${HOME}/.config/spotify
mkdir ${HOME}/.local/share/spotify
whitelist ${HOME}/.cache/spotify
whitelist ${HOME}/.config/spotify
whitelist ${HOME}/.local/share/spotify
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
#nodbus - dbus needed for MPRIS
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin bash,cat,dirname,find,grep,head,rm,sh,spotify,tclsh,touch,zenity
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,spotify,ssl,xdg
private-opt spotify
private-srv none
private-tmp

