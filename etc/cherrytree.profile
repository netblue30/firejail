# cherrytree note taking application
noblacklist /usr/bin/python2*
noblacklist /usr/lib/python3*
noblacklist ${HOME}/.config/cherrytree
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
nosound
seccomp
protocol unix,inet,inet6,netlink
tracelog


