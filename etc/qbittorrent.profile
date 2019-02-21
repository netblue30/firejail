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
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/qBittorrent
mkdir ${HOME}/.config/qBittorrent
mkdir ${HOME}/.local/share/data/qBittorrent
whitelist  ${DOWNLOADS}
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

private-bin qbittorrent,python*
private-dev
# private-etc alternatives,X11,fonts,xdg,resolv.conf,ca-certificates,ssl,pki,crypto-policies
# private-lib - problems on Arch
private-tmp

# memory-deny-write-execute - problems on  Arch, see #1690 on GitHub repo
noexec ${HOME}
noexec /tmp
