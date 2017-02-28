# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/audacious.local

# Audacious media player profile
noblacklist ~/.config/audacious
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
