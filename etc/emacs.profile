# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/emacs.local

# emacs profile
noblacklist ~/.emacs
noblacklist ~/.emacs.d

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc


caps.drop all
netfilter
nonewprivs
noroot
nogroups
protocol unix,inet,inet6
seccomp
