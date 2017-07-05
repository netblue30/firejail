# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/franz.local

# Franz profile
noblacklist ~/.config/Franz
noblacklist ~/.cache/Franz
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

whitelist ${DOWNLOADS}
mkdir ~/.config/Franz
whitelist ~/.config/Franz
mkdir ~/.cache/Franz
whitelist ~/.cache/Franz
mkdir ~/.pki
whitelist ~/.pki

include /etc/firejail/whitelist-common.inc

caps.drop all
#ipc-namespace
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-dev
private-tmp
disable-mnt

noexec ${HOME}
noexec /tmp
