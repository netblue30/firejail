# Firejail profile for desktop
# Description: Extend your GitHub workflow beyond your browser with GitHub Desktop
# This file is overwritten after every install/update
# Persistent local customizations
include github-desktop.local
# Persistent global definitions
include globals.local

whitelist ${HOME}/.gitconfig
whitelist ${HOME}/.config/GitHub Desktop

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-devel.inc
include disable-interpreters.inc

include whitelist-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
# private-bin Atom,desktop
# private-cache
# private-dev
# private-etc none
# private-lib
# private-tmp

# memory-deny-write-execute
# noexec ${HOME}
# noexec /tmp
