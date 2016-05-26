# Skype profile
noblacklist ${HOME}/.Skype
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
seccomp
protocol unix,inet,inet6
