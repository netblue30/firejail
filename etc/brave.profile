# Profile for Brave browser

noblacklist ~/.config/brave
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp

whitelist ${DOWNLOADS}

mkdir ~/.config/brave
whitelist ~/.config/brave
