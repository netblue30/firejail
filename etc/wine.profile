# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/wine.local

# wine profile
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.local/share/steam
noblacklist ${HOME}/.wine

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
seccomp
