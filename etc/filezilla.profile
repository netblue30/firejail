# FileZilla ftp profile
noblacklist ${HOME}/.filezilla
noblacklist ${HOME}/.config/filezilla
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

blacklist ${HOME}/.wine

caps.drop all
seccomp
protocol unix,inet,inet6
noroot
netfilter
nosound



