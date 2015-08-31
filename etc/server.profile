# generic server profile
# it allows /sbin and /usr/sbin directories - this is where servers are installed
include /etc/firejail/disable-mgmt.inc sbin
private
private-dev
seccomp

