# FileZilla ftp profile
noblacklist ${HOME}/.filezilla
noblacklist ${HOME}/.config/filezilla

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
