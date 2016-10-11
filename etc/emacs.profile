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
