# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/server.local

# generic server profile
# it allows /sbin and /usr/sbin directories - this is where servers are installed
noblacklist /sbin
noblacklist /usr/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

blacklist /tmp/.X11-unix

no3d
nosound
seccomp

private
private-dev
private-tmp
