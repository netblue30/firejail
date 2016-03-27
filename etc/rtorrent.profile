# rtorrent bittorrent profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-terminals.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot
nosound
