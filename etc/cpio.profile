# cpio profile
# /sbin and /usr/sbin are visible inside the sandbox
# /boot is not visible and /var is heavily modified 
quiet
noblacklist /sbin
noblacklist /usr/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

private-dev
seccomp
caps.drop all
net none
shell none
tracelog
net none
nosound
no3d

blacklist /tmp/.X11-unix

