# FileZilla ftp profile
noblacklist ${HOME}/.filezilla
noblacklist ${HOME}/.config/filezilla

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6
nonewprivs
noroot
netfilter
nosound
