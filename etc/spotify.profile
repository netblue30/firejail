# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/spotify.local

# Spotify media player profile
noblacklist ${HOME}/.config/spotify
noblacklist ${HOME}/.local/share/spotify
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

# Whitelist the folders needed by Spotify
mkdir ${HOME}/.config/spotify
whitelist ${HOME}/.config/spotify
mkdir ${HOME}/.local/share/spotify
whitelist ${HOME}/.local/share/spotify

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin spotify
private-etc fonts,machine-id,pulse,resolv.conf
private-dev
private-tmp

blacklist ${HOME}/.Xauthority
blacklist ${HOME}/.bashrc
blacklist /boot
blacklist /lost+found
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /root
blacklist /sbin
blacklist /srv
blacklist /sys
blacklist /var
