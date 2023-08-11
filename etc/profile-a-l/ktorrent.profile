# Firejail profile for ktorrent
# Description: BitTorrent client based on the KDE platform
# This file is overwritten after every install/update
# Persistent local customizations
include ktorrent.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ktorrentrc
noblacklist ${HOME}/.kde/share/apps/ktorrent
noblacklist ${HOME}/.kde/share/config/ktorrentrc
noblacklist ${HOME}/.kde4/share/apps/ktorrent
noblacklist ${HOME}/.kde4/share/config/ktorrentrc
noblacklist ${HOME}/.local/share/ktorrent
noblacklist ${HOME}/.local/share/kxmlgui5/ktorrent

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

# Legacy paths
#mkdir ${HOME}/.kde/share/apps/ktorrent
#mkdir ${HOME}/.kde/share/config
#mkdir ${HOME}/.kde4/share/apps/ktorrent
#mkdir ${HOME}/.kde4/share/config
#mkfile ${HOME}/.kde/share/config/ktorrentrc
#mkfile ${HOME}/.kde4/share/config/ktorrentrc

mkdir ${HOME}/.local/share/ktorrent
mkdir ${HOME}/.local/share/kxmlgui5/ktorrent
mkfile ${HOME}/.config/ktorrentrc
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/ktorrentrc
whitelist ${HOME}/.kde/share/apps/ktorrent
whitelist ${HOME}/.kde/share/config/ktorrentrc
whitelist ${HOME}/.kde4/share/apps/ktorrent
whitelist ${HOME}/.kde4/share/config/ktorrentrc
whitelist ${HOME}/.local/share/ktorrent
whitelist ${HOME}/.local/share/kxmlgui5/ktorrent
include whitelist-common.inc
include whitelist-run-common.inc
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

private-bin kbuildsycoca4,kdeinit4,ktmagnetdownloader,ktorrent,ktupnptest
private-dev
#private-lib # problems on Arch
private-tmp

deterministic-shutdown
#memory-deny-write-execute
restrict-namespaces
