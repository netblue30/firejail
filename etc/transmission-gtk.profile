# transmission-gtk bittorrent profile
noblacklist ${HOME}/.config/transmission
noblacklist ${HOME}/.cache/transmission

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
tracelog

private-bin transmission-gtk
private-dev
private-tmp
