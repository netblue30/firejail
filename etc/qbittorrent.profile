# Firejail profile for qbittorrent
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qbittorrent.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/qBittorrent
noblacklist ${HOME}/.config/qBittorrent
noblacklist ${HOME}/.config/qBittorrentrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/qBittorrent
mkdir ${HOME}/.config/qBittorrent
mkdir ${HOME}/.local/share/data/qBittorrent
whitelist  ${DOWNLOADS}
whitelist ${HOME}/.cache/qBittorrent
whitelist ${HOME}/.config/qBittorrent
whitelist ${HOME}/.config/qBittorrentrc
whitelist ${HOME}/.local/share/data/qBittorrent
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

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
shell none

private-bin qbittorrent,python*
private-dev
# private-etc X11,fonts,xdg,resolv.conf
# private-lib - problems on Arch
private-tmp

# memory-deny-write-execute - problems on  Arch, see #1690 on GitHub repo
noexec ${HOME}
noexec /tmp
