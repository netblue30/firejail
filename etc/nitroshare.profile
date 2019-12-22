# Firejail profile for nitroshare
# Description: Network File Transfer Application
# This file is overwritten after every install/update
# Persistent local customizations
include nitroshare.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Nathan Osman
noblacklist ${HOME}/.config/NitroShare

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

caps.drop all
netfilter
no3d
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin awk,grep,nitroshare,nitroshare-cli,nitroshare-nmh,nitroshare-send,nitroshare-ui
private-cache
private-dev
private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
# private-lib libnitroshare.so.*,libqhttpengine.so.*,libqmdnsengine.so.*,nitroshare
private-tmp

# memory-deny-write-execute
