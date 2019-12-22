# Firejail profile for qbittorrent
# Description: BitTorrent client based on libtorrent-rasterbar with a Qt5 GUI
# This file is overwritten after every install/update
# Persistent local customizations
include qbittorrent.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/qBittorrent
noblacklist ${HOME}/.config/qBittorrent
noblacklist ${HOME}/.config/qBittorrentrc
noblacklist ${HOME}/.local/share/data/qBittorrent

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/qBittorrent
mkdir ${HOME}/.config/qBittorrent
mkfile ${HOME}/.config/qBittorrentrc
mkdir ${HOME}/.local/share/data/qBittorrent
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/qBittorrent
whitelist ${HOME}/.config/qBittorrent
whitelist ${HOME}/.config/qBittorrentrc
whitelist ${HOME}/.local/share/data/qBittorrent
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
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

private-bin python*,qbittorrent
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,ca-certificates,crypto-policies,drirc,fonts,glvnd,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,tor,xdg
private-tmp

# memory-deny-write-execute - problems on Arch, see #1690 on GitHub repo
