# Firejail profile for cower
# This file is overwritten after every install/update

# This profile could be significantly strengthened by adding the following to cower.local
# whitelist ~/<Your Build Folder>
# whitelist ~/.config/cower/

quiet

# Persistent local customizations
include /etc/firejail/cower.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/cower/config
read-only ~/.config/cower/config

noblacklist /var/lib/pacman

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin cower
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
