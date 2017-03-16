# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/keepass.local

# keepass password manager profile
noblacklist ${HOME}/.keepass
noblacklist ${HOME}/.config/keepass
noblacklist ${HOME}/.config/KeePass
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/*.kdb
 
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
netfilter
shell none

#private-tmp - mask KDE problems
private-dev
