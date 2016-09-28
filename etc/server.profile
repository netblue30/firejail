# generic server profile
# it allows /sbin and /usr/sbin directories - this is where servers are installed
noblacklist /sbin
noblacklist /usr/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

private
private-dev
nosound
no3d
private-tmp
blacklist /tmp/.X11-unix
seccomp

