# Firejail profile for dolphin
# Description: File manager
# This file is overwritten after every install/update
# Persistent local customizations
include dolphin.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/Trash
# noblacklist ${HOME}/.cache/dolphin - disable-programs.inc is disabled, see below
# noblacklist ${HOME}/.config/dolphinrc
# noblacklist ${HOME}/.local/share/dolphin

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# dolphin needs to be able to start arbitrary applications so we cannot blacklist their files
# include disable-programs.inc

allusers
caps.drop all
# net none
netfilter
nodvd
nogroups
nonewprivs
# Comment the next line (or put 'ignore noroot' in your dolphin.local) if you use MPV+Vulkan (see issue #3012)
noroot
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
# private-tmp

join-or-start dolphin
