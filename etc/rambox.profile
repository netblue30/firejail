# Firejail profile for rambox
# This file is overwritten after every install/update
# Persistent local customizations
include rambox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Rambox
noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/Rambox
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Rambox
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
# tracelog

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
