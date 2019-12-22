# Firejail profile for kiwix-desktop
# Description: view/manage ZIM files
# This file is overwritten after every install/update
# Persistent local customizations
include kiwix-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/kiwix
noblacklist ${HOME}/.local/share/kiwix-desktop

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/kiwix
mkdir ${HOME}/.local/share/kiwix-desktop
whitelist ${HOME}/.local/share/kiwix
whitelist ${HOME}/.local/share/kiwix-desktop
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
# no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none

disable-mnt
private-cache
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp
