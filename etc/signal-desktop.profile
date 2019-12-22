# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include signal-desktop.local
# Persistent global definitions
include globals.local

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
ignore noexec /tmp

noblacklist ${HOME}/.config/Signal

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-passwdmgr.inc

mkdir ${HOME}/.config/Signal
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Signal
include whitelist-common.inc
include whitelist-var-common.inc

caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
notv
nou2f
shell none

disable-mnt
private-dev
private-tmp
