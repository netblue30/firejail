# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/silentarmy.local

# Firejail profile for SILENTARMY

include /etc/firejail/disable-common.inc
#include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private
#private-bin silentarmy,sa-solver,python3
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
