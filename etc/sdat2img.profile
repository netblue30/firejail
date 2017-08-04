quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/sdat2img.local

# Firejail profile for sdat2img
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
no3d
net none
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix
seccomp
shell none

private-dev

noexec ${HOME}
noexec /tmp
