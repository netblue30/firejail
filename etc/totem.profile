# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/totem.local

# Totem media player profile
noblacklist ~/.config/totem
noblacklist ~/.local/share/totem

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nonewprivs
noroot
netfilter
protocol unix,inet,inet6
seccomp
