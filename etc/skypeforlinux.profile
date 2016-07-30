# skypeforlinux profile
noblacklist ${HOME}/.config/skypeforlinux
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
caps.drop all
netfilter
noroot
seccomp
protocol unix,inet,inet6,netlink
