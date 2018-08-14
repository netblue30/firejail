# Firejail profile for ktorrent
# Description: BitTorrent client based on the KDE platform
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ktorrent.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/ktorrentrc
noblacklist ${HOME}/.kde/share/apps/ktorrent
noblacklist ${HOME}/.kde/share/config/ktorrentrc
noblacklist ${HOME}/.kde4/share/apps/ktorrent
noblacklist ${HOME}/.kde4/share/config/ktorrentrc
noblacklist ${HOME}/.local/share/ktorrent

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.kde/share/apps/ktorrent
mkdir ${HOME}/.kde4/share/apps/ktorrent
mkdir ${HOME}/.local/share/ktorrent
mkfile ${HOME}/.config/ktorrentrc
mkfile ${HOME}/.kde/share/config/ktorrentrc
mkfile ${HOME}/.kde4/share/config/ktorrentrc
whitelist  ${DOWNLOADS}
whitelist ${HOME}/.config/ktorrentrc
whitelist ${HOME}/.kde/share/apps/ktorrent
whitelist ${HOME}/.kde/share/config/ktorrentrc
whitelist ${HOME}/.kde4/share/apps/ktorrent
whitelist ${HOME}/.kde4/share/config/ktorrentrc
whitelist ${HOME}/.local/share/ktorrent
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin ktorrent,kbuildsycoca4,kdeinit4
private-dev
# private-lib - problems on Arch
private-tmp

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
