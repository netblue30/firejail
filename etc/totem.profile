# Totem media player profile
noblacklist ~/.config/totem
noblacklist ~/.local/share/totem
noblacklist /mnt
noblacklist /media
noblackist /run/media

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nonewprivs
noroot
netfilter
protocol unix,inet,inet6
seccomp
