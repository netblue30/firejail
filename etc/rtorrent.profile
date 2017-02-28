# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/rtorrent.local

# rtorrent bittorrent profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp

shell none
private-bin rtorrent
private-dev
private-tmp