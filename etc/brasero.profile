# brasero profile
noblacklist ~/.config/brasero
noblacklist /mnt
noblacklist /media
noblackist /run/media

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin brasero
# private-tmp
# private-dev
# private-etc fonts
