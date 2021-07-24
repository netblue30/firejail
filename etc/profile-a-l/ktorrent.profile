# Firejail profile for ktorrent
# Description: BitTorrent client based on the KDE platform
# This file is overwritten after every install/update
# Persistent local customizations
include ktorrent.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/ktorrentrc
nodeny  ${HOME}/.kde/share/apps/ktorrent
nodeny  ${HOME}/.kde/share/config/ktorrentrc
nodeny  ${HOME}/.kde4/share/apps/ktorrent
nodeny  ${HOME}/.kde4/share/config/ktorrentrc
nodeny  ${HOME}/.local/share/ktorrent
nodeny  ${HOME}/.local/share/kxmlgui5/ktorrent

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.kde/share/apps/ktorrent
mkdir ${HOME}/.kde4/share/apps/ktorrent
mkdir ${HOME}/.local/share/ktorrent
mkdir ${HOME}/.local/share/kxmlgui5/ktorrent
mkfile ${HOME}/.config/ktorrentrc
mkfile ${HOME}/.kde/share/config/ktorrentrc
mkfile ${HOME}/.kde4/share/config/ktorrentrc
allow  ${DOWNLOADS}
allow  ${HOME}/.config/ktorrentrc
allow  ${HOME}/.kde/share/apps/ktorrent
allow  ${HOME}/.kde/share/config/ktorrentrc
allow  ${HOME}/.kde4/share/apps/ktorrent
allow  ${HOME}/.kde4/share/config/ktorrentrc
allow  ${HOME}/.local/share/ktorrent
allow  ${HOME}/.local/share/kxmlgui5/ktorrent
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin kbuildsycoca4,kdeinit4,ktorrent
private-dev
# private-lib - problems on Arch
private-tmp

# memory-deny-write-execute
