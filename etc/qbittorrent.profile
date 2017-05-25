# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/qbittorrent.local

# qbittorrent bittorrent profile
noblacklist ~/.config/qt5ct
noblacklist ~/.config/qBittorrent
noblacklist ~/.cache/qBittorrent

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ~/.local/share/data/qBittorrent
whitelist ~/.local/share/data/qBittorrent
whitelist ~/.config/qt5ct
mkdir ~/.config/qBittorrent
whitelist ~/.config/qBittorrent
mkdir ~/.cache/qBittorrent
whitelist ~/.cache/qBittorrent
whitelist  ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc

caps.drop all
machine-id
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp

# there are some problems with "Open destination folder", see bug #536
#shell none
#private-bin qbittorrent
private-dev
private-tmp
