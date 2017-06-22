quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/cpio.local

# cpio profile
# /sbin and /usr/sbin are visible inside the sandbox
# /boot is not visible and /var is heavily modified
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
