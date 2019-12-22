# Firejail profile for falkon
# Description: Lightweight web browser based on Qt WebEngine
# This file is overwritten after every install/update
# Persistent local customizations
include falkon.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/falkon
noblacklist ${HOME}/.config/falkon

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/falkon
mkdir ${HOME}/.config/falkon
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/falkon
whitelist ${HOME}/.config/falkon
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
# blacklisting of chroot system calls breaks falkon
seccomp !chroot
# tracelog

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,glvnd,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
# private-tmp - interferes with the opening of downloaded files

