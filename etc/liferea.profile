# Firejail profile for liferea
# Description: Feed/news/podcast client with plugin support
# This file is overwritten after every install/update
# Persistent local customizations
include liferea.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/liferea
noblacklist ${HOME}/.config/liferea
noblacklist ${HOME}/.local/share/liferea

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/liferea
mkdir ${HOME}/.config/liferea
mkdir ${HOME}/.local/share/liferea
whitelist ${HOME}/.cache/liferea
whitelist ${HOME}/.config/liferea
whitelist ${HOME}/.local/share/liferea
whitelist /usr/share/liferea
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

