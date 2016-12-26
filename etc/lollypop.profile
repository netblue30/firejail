#
#Profile for lollypop
#

#No Blacklist Paths
noblacklist ${HOME}/.local/share/lollypop
noblacklist /mnt
noblacklist /media
noblackist /run/media

#Blacklist Paths
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

#Options
caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
