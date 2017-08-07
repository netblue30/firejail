# Firejail profile for cpio
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/cpio.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist /sbin
noblacklist /usr/sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
net none
no3d
nosound
seccomp
shell none
tracelog

private-dev

# CLOBBERED COMMENTS
# /boot is not visible and /var is heavily modified
# /sbin and /usr/sbin are visible inside the sandbox
