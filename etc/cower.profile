# Firejail profile for cower
# This file is overwritten after every install/update

# This profile could be significantly strengthened by adding the following to cower.local
# whitelist ${HOME}/<Your Build Folder>
# whitelist ${HOME}/.config/cower/

quiet

# Persistent local customizations
include cower.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/cower/config
read-only ${HOME}/.config/cower/config

noblacklist /var/lib/pacman

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin cower
private-dev
private-tmp

memory-deny-write-execute
