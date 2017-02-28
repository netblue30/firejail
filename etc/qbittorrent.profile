# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/qbittorrent.local

# qbittorrent bittorrent profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
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
