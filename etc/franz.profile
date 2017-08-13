# Firejail profile for franz
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/franz.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/Franz
noblacklist ~/.config/Franz
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/Franz
mkdir ~/.config/Franz
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/Franz
whitelist ~/.config/Franz
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
