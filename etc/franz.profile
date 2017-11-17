# Firejail profile for franz
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/franz.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/Franz
noblacklist ${HOME}/.config/Franz
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/Franz
mkdir ${HOME}/.config/Franz
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/Franz
whitelist ${HOME}/.config/Franz
whitelist ${HOME}/.pki
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
