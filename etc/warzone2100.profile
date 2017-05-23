# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/warzone2100.local

# Firejail profile for warzone2100
noblacklist ~/.warzone2100-3.*
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Whitelist
#mkdir ~/.warzone2100-3.1
whitelist ~/.warzone2100-3.1
#mkdir ~/.warzone2100-3.2
whitelist ~/.warzone2100-3.2

# Call these options
caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin warzone2100
private-dev
private-tmp
