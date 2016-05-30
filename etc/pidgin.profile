# Pidgin profile
noblacklist ${HOME}/.purple

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
