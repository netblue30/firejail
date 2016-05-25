# Profile for Brave browser

noblacklist ~/.config/brave
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
noroot

whitelist ${DOWNLOADS}

mkdir ~/.config
mkdir ~/.config/brave
whitelist ~/.config/brave
