# Firejail profile for crow
# Description: A translator that allows to translate and say selected text using Google, Yandex and Bing translate API
# This file is overwritten after every install/update
# Persistent local customizations
include crow.local
# Persistent global definitions
include globals.local

mkdir ${HOME}/.config/crow
mkdir ${HOME}/.cache/gstreamer-1.0
whitelist ${HOME}/.config/crow
whitelist ${HOME}/.cache/gstreamer-1.0

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin crow
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-opt none
private-tmp
private-srv none

