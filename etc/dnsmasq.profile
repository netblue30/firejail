# dnsmasq profile
noblacklist /sbin
noblacklist /usr/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-terminals.inc
caps
seccomp
protocol unix,inet,inet6,netlink
netfilter
private
private-dev
