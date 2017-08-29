# Firejail profile for qbittorrent
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qbittorrent.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/qBittorrent
noblacklist ~/.config/qBittorrent
noblacklist ~/.config/qBittorrentrc
noblacklist ~/.config/qt5ct

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/qBittorrent
mkdir ~/.config/qBittorrent
mkdir ~/.local/share/data/qBittorrent
whitelist  ${DOWNLOADS}
whitelist ~/.cache/qBittorrent
whitelist ~/.config/qBittorrent
whitelist ~/.config/qBittorrentrc
whitelist ~/.config/qt5ct
whitelist ~/.local/share/data/qBittorrent
include /etc/firejail/whitelist-common.inc

caps.drop all
machine-id
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
# shell none

# private-bin qbittorrent
private-dev
# private-etc X11,fonts,xdg,resolv.conf
private-tmp
