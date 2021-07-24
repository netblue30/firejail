# Firejail profile for ferdi
# This file is overwritten after every install/update
# Persistent local customizations
include ferdi.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

nodeny  ${HOME}/.cache/Ferdi
nodeny  ${HOME}/.config/Ferdi
nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/Ferdi
mkdir ${HOME}/.config/Ferdi
mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
allow  ${DOWNLOADS}
allow  ${HOME}/.cache/Ferdi
allow  ${HOME}/.config/Ferdi
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
