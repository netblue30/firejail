# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/pix.local

# Firejail profile for pix
noblacklist ${HOME}/.config/pix
noblacklist ${HOME}/.local/share/pix
noblacklist ~/.Steam
noblacklist ~/.steam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin pix
private-dev
private-tmp
