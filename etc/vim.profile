# vim profile
noblacklist ~/.vim
noblacklist ~/.vimrc
noblacklist ~/.viminfo

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
