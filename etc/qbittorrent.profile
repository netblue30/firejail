# qbittorrent bittorrent profile
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

# there are some problems with "Open destination folder", see bug #536
#shell none
#private-bin qbittorrent
private-dev
private-tmp
