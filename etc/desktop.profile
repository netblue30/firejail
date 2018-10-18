# Firejail profile for desktop
# Description: Extend your GitHub workflow beyond your browser with GitHub Desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/github-desktop.local
# Persistent global definitions
include /etc/firejail/globals.local

whitelist ${HOME}/.gitconfig
whitelist ${HOME}/.config/GitHub Desktop

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc

include /etc/firejail/whitelist-common.inc

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
