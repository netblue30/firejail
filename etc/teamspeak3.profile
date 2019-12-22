# Firejail profile for teamspeak3
# Description: TeamSpeak is software for quality voice communication via the Internet
# This file is overwritten after every install/update
# Persistent local customizations
include teamspeak3.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.ts3client
noblacklist ${PATH}/openssl

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.ts3client
whitelist ${DOWNLOADS}
whitelist ${HOME}/.ts3client
include whitelist-common.inc

caps.drop all
ipc-namespace
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
seccomp !chroot
shell none

disable-mnt
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

