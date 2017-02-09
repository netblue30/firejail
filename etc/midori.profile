# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/midori.local

# Midori browser profile
noblacklist ${HOME}/.config/midori
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
# noroot - noroot break midori on Ubuntu 14.04
protocol unix,inet,inet6
seccomp

