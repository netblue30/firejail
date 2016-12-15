# Firejail profile for zoom.us
noblacklist ~/.config/zoomus.conf

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc


# Whitelists

mkdir ~/.zoom
whitelist ~/.zoom


caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

private-tmp
