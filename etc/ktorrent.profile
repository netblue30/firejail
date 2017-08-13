# Firejail profile for ktorrent
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ktorrent.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/ktorrentrc
noblacklist ~/.kde/share/apps/ktorrent
noblacklist ~/.kde/share/config/ktorrentrc
noblacklist ~/.kde4/share/apps/ktorrent
noblacklist ~/.kde4/share/config/ktorrentrc
noblacklist ~/.local/share/ktorrent

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.kde/share/apps/ktorrent
mkdir ~/.kde/share/config/ktorrentrc
mkdir ~/.kde4/share/apps/ktorrent
mkdir ~/.kde4/share/config/ktorrentrc
mkdir ~/.local/share/ktorrent
mkfile ~/.config/ktorrentrc
whitelist  ${DOWNLOADS}
whitelist ~/.config/ktorrentrc
whitelist ~/.kde/share/apps/ktorrent
whitelist ~/.kde/share/config/ktorrentrc
whitelist ~/.kde4/share/apps/ktorrent
whitelist ~/.kde4/share/config/ktorrentrc
whitelist ~/.local/share/ktorrent
include /etc/firejail/whitelist-common.inc

caps.drop all
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

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
