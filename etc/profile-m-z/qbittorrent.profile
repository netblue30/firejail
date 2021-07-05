# Firejail profile for qbittorrent
# Description: BitTorrent client based on libtorrent-rasterbar with a Qt5 GUI
# This file is overwritten after every install/update
# Persistent local customizations
include qbittorrent.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/qBittorrent
nodeny  ${HOME}/.config/qBittorrent
nodeny  ${HOME}/.config/qBittorrentrc
nodeny  ${HOME}/.local/share/data/qBittorrent

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.cache/qBittorrent
mkdir ${HOME}/.config/qBittorrent
mkfile ${HOME}/.config/qBittorrentrc
mkdir ${HOME}/.local/share/data/qBittorrent
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/qBittorrent
allow  ${HOME}/.config/qBittorrent
allow  ${HOME}/.config/qBittorrentrc
allow  ${HOME}/.local/share/data/qBittorrent
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
nogroups
noinput
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
# private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,resolv.conf,ssl,X11,xdg
private-tmp

# See https://github.com/netblue30/firejail/issues/3707 for tray-icon
dbus-user none
dbus-system none

# memory-deny-write-execute - problems on Arch, see #1690 on GitHub repo
