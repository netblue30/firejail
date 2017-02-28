# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/cherrytree.local

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
nogroups
nonewprivs
noroot
nosound
seccomp
protocol unix,inet,inet6,netlink
tracelog
