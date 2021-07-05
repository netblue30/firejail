# Firejail profile for franz
# This file is overwritten after every install/update
# Persistent local customizations
include franz.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

nodeny  ${HOME}/.cache/Franz
nodeny  ${HOME}/.config/Franz
nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/Franz
mkdir ${HOME}/.config/Franz
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/Franz
allow  ${HOME}/.config/Franz
allow  ${HOME}/.pki
allow  ${HOME}/.local/share/pki
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none

disable-mnt
private-dev
private-tmp
