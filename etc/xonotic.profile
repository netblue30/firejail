# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/xonotic.local

#
#Profile for xonotic
#

#No Blacklist Paths
noblacklist ${HOME}/.xonotic

#Blacklist Paths
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

#Whitelist Paths
mkdir ${HOME}/.xonotic
whitelist ${HOME}/.xonotic
include /etc/firejail/whitelist-common.inc

#Options
caps.drop all
#ipc-namespace
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-bin xonotic-sdl,xonotic-glx,blind-id
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
