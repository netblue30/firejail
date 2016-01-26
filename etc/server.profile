# generic server profile
# it allows /sbin and /usr/sbin directories - this is where servers are installed
noblacklist /sbin
noblacklist /usr/sbin
include /etc/firejail/disable-mgmt.inc
private
private-dev
private-tmp
seccomp

