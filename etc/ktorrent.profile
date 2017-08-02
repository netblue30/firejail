# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/ktorrent.local

noblacklist ~/.config/ktorrentrc
noblacklist ~/.local/share/ktorrent
noblacklist ~/.kde/share/config/ktorrentrc
noblacklist ~/.kde4/share/config/ktorrentrc
noblacklist ~/.kde/share/apps/ktorrent
noblacklist ~/.kde4/share/apps/ktorrent

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

mkfile ~/.config/ktorrentrc
whitelist ~/.config/ktorrentrc
mkdir ~/.local/share/ktorrent
whitelist ~/.local/share/ktorrent
mkdir ~/.kde/share/config/ktorrentrc
whitelist ~/.kde/share/config/ktorrentrc
mkdir ~/.kde4/share/config/ktorrentrc
whitelist ~/.kde4/share/config/ktorrentrc
mkdir ~/.kde/share/apps/ktorrent
whitelist ~/.kde/share/apps/ktorrent
mkdir ~/.kde4/share/apps/ktorrent
whitelist ~/.kde4/share/apps/ktorrent
whitelist  ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc


caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
