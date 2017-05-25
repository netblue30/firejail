# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/ktorrent.local

################################
# Generic GUI application profile
################################
noblacklist ~/.kde/share/config/ktorrentrc
noblacklist ~/.kde4/share/config/ktorrentrc
noblacklist ~/.kde/share/apps/ktorrent
noblacklist ~/.kde4/share/apps/ktorrent
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc


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
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

#
# depending on your usage, you can enable some of the commands below:
#
nogroups
shell none
# private-bin program
# private-etc none
private-dev
# private-tmp
