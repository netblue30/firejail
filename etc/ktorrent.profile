# Firejail profile for ktorrent
# Description: BitTorrent client based on the KDE platform
# This file is overwritten after every install/update
# Persistent local customizations
include ktorrent.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ktorrentrc
noblacklist ${HOME}/.kde/share/apps/ktorrent
noblacklist ${HOME}/.kde/share/config/ktorrentrc
noblacklist ${HOME}/.kde4/share/apps/ktorrent
noblacklist ${HOME}/.kde4/share/config/ktorrentrc
noblacklist ${HOME}/.local/share/ktorrent

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.kde/share/apps/ktorrent
mkdir ${HOME}/.kde4/share/apps/ktorrent
mkdir ${HOME}/.local/share/ktorrent
mkfile ${HOME}/.config/ktorrentrc
mkfile ${HOME}/.kde/share/config/ktorrentrc
mkfile ${HOME}/.kde4/share/config/ktorrentrc
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/ktorrentrc
whitelist ${HOME}/.kde/share/apps/ktorrent
whitelist ${HOME}/.kde/share/config/ktorrentrc
whitelist ${HOME}/.kde4/share/apps/ktorrent
whitelist ${HOME}/.kde4/share/config/ktorrentrc
whitelist ${HOME}/.local/share/ktorrent
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
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

private-bin kbuildsycoca4,kdeinit4,ktorrent
private-dev
#private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,fonts,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,tor,xdg
# private-lib - problems on Arch
private-tmp

# memory-deny-write-execute
