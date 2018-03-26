# Firejail profile for mumble
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mumble.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Mumble
noblacklist ${HOME}/.local/share/data/Mumble

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/Mumble
mkdir ${HOME}/.local/share/data/Mumble
whitelist ${HOME}/.config/Mumble
whitelist ${HOME}/.local/share/data/Mumble
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin mumble
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
