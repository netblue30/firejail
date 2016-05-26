# Weechat IRC profile
noblacklist ${HOME}/.weechat
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
nonewprivs
noroot
netfilter
